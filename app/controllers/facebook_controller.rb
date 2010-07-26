class FacebookController < ApplicationController
  #Stellt sicher, dass dieser Controller nur über Facebook geöffnet wird
  before_filter :ensure_authenticated_to_facebook

  #Findet die Autohaus-Kontakte
  before_filter :find_contacts, :only => [:index]

  #Behandle den Flash
  before_filter :handle_flash

  #Speichere Facebook-Informationen
  before_filter :save_facebook_information, :only => [:index]

  #Behandle Freund-Informationen
  before_filter :update_friend_information, :only => [:index]

  #Hole neue Kommentare zu Aufträgen
  before_filter :update_comments, :only => [:index]

  #Hole Autos mit fälliger Untersuchung
  before_filter :find_cars, :only => [:index]

  #Hole Kampagnen, die auf den Nutzer zutreffen
  before_filter :find_campaigns, :only => [:index]

  #Rendere Facebook-Layout (FBML)
  layout "facebook"

  def index
    @title = "Startseite"
  end

  # Falls es einen Facebook-Kontakt mit dem angegebenen Freischaltcode gibt,
  # füge diesen zur Applikation hinzu
  def accept_token
    facebook_account = FacebookAccount.find_by_token params[:token]

    if(facebook_account)
      #Da der Primary Key des Facebook-Accounts die uid ist, kann ActiveRecord
      #hier kein UPDATE ... WHERE 'uid' machen - warum auch immer
      FacebookAccount.connection().execute("UPDATE facebook_accounts SET uid = #{@facebook_session.user.uid} WHERE contact_id = #{facebook_account.contact_id}")

      redirect_to :action => 'index', :flash_notice => 'Freischaltcode erfolgreich erkannt.'
    else
      redirect_to :action => 'index', :flash_error => 'Freischaltcode wurde nicht erkannt.'
    end
  end

  def invite
    #Die UIDs der Freunde des gerade eingeloggten Nutzers
    friend_ids = params[:fb_sig_friends].split(",")

    # Die UIDs der Freunde, die einen Account bei der Autohaus-App haben
    # uniq, da es mehrere Freunde mit denselben UIDs geben kann
    @friend_ids_with_account = FacebookAccount.find_all_by_uid(friend_ids).collect { |friend| friend.uid }.uniq.join(",")
  end

  def message

  end


  def send_message
    if params[:message] == nil
      redirect_to :action => :message, :flash_error => 'Nachricht muss angegeben werden.'
    else
      UserMessage.deliver_user_message(@facebook_session.user, params[:message], params[:subject])

      redirect_to :action => :index, :flash_notice => 'Nachricht erfolgreich verschickt.'
    end
  end

  #Um die Berechtigung zu erhalten, erweiterte Stati lesen zu dürfen, muss zur Graph API weitergeleitet werden
  def authorize_extended
    redirect_to "https://graph.facebook.com/oauth/authorize?client_id=#{Facebooker.api_key}&redirect_uri=#{url_for :action => 'index', :only_path => false}&scope=user_about_me,user_birthday,user_hometown,user_interests,user_work_history"
  end

  private

  # Sucht die zu dem Facebook-Nutzer zugehörigen Anwendungs-Accounts
  def find_contacts
    @facebook_accounts = FacebookAccount.find_all_by_uid @facebook_session.user.uid
    @contacts = []

    @facebook_accounts.each { |account| @contacts << account.contact unless account.contact.nil? }
  end

  # Irgendwie wird der Flash nicht mit der Session übergeben
  # Also muss der Flash über die Request-Variablen "flash_notice" und "flash_error" übergeben werden
  def handle_flash
    if(params[:flash_notice] != nil)
      flash.now[:notice] = params[:flash_notice]
    end

    if(params[:flash_error] != nil)
      flash.now[:error] = params[:flash_error]
    end
  end

  #Speichert die Facebook-Informationen eines Kontakts
  def save_facebook_information
    @facebook_session.user.populate

    FacebookInformation.update_from_facebooker_user(@facebook_session.user)
  end

  #Aktualisiert die in der Datenbank gespeicherten Freunde
  def update_friend_information
    #Die UIDs der Freunde des gerade eingeloggten Nutzers
    friend_ids = params[:fb_sig_friends].split(",")

    # Die UIDs der Freunde, die einen Account bei der Autohaus-App haben
    # uniq, da es mehrere Freunde mit denselben UIDs geben kann
    friend_ids_with_account = FacebookAccount.find_all_by_uid(friend_ids).collect { |friend| friend.uid }.uniq

    unless friend_ids_with_account.empty?
      #Aktualisiere die Facebook-Freundinformationen
      sql = ActiveRecord::Base.connection();
      sql.execute "SET autocommit=0";
      sql.begin_db_transaction
      sql.execute "DELETE FROM facebook_friends WHERE friendof = #{@facebook_session.user}";
      sql.execute "DELETE FROM facebook_friends WHERE uid = #{@facebook_session.user}";
      friend_ids_with_account.each do |friend_id|
        sql.execute "INSERT INTO facebook_friends SET uid = #{friend_id}, friendof = #{@facebook_session.user}"
        sql.execute "INSERT INTO facebook_friends SET uid = #{@facebook_session.user}, friendof = #{friend_id}"
      end
      sql.commit_db_transaction
    end
  end

  #Speichert neue Kommentare zu Aufträgen des Autohauses in der Datenbank
  def update_comments
    facebook_posts = @facebook_session.fql_query("SELECT post_id, message, app_id, app_data, created_time FROM stream WHERE source_id=#{@facebook_session.user}").select{|post| post["app_id"] == params[:fb_sig_app_id]}

    #Füge Posts in Datenbank ein, falls noch nicht vorhanden
    facebook_posts.each do |post|
      begin
        order_id = post["app_data"]["attachment_data"].match(/"order_id":(.*?),/)[1];
      rescue NoMethodError
        order_id = nil
      end

      begin
        FacebookComment.create(:order_id => order_id, :text => post["message"], :uid => @facebook_session.user.uid, :created_at => post["created_time"], :post_id => post["post_id"])
      rescue ActiveRecord::StatementInvalid
        #Ignoriere Fehlermeldung, falls es den Post schon in der Datenbank gibt
      end

      facebook_comments_for_post = @facebook_session.fql_query("SELECT fromid, time, text, id FROM comment WHERE post_id = '#{post["post_id"]}'")

      facebook_comments_for_post.each do |comment|
        begin
          FacebookComment.create(:order_id => order_id, :text => comment["text"], :uid => comment["fromid"], :created_at => comment["time"], :post_id => comment["id"])
        rescue
          #Ignoriere Fehlermeldung, falls es den Post schon in der Datenbank gibt
        end
      end
    end
  end

  #Finde Autos mit fälliger Untersuchung
  def find_cars
    cars = @contacts.collect { |contact| contact.cars }.flatten

    unless cars.empty?
      @due_cars = cars.select { |c| c.inspection_due }
    else
      @due_cars = []
    end
  end

  #Finde Kampagnen, die auf den User zutreffen
  def find_campaigns
    account = FacebookAccount.find_by_uid @facebook_session.user.id
    
    @campaigns = Campaign.find(:all).select { |campaign| campaign.matches?(account) }
  end
end