class FacebookAccountsController < ApplicationController
  
  before_filter :require_admin, :only => [:destroy_from_admin]

  # Erzeugt einen neuen Facebook-Account
  # Dieser muss vom Nutzer über die Facebook-Applikation über den automatisch
  # (im Modell) erzeugten Freischaltcode "aktiviert" werden
  def new
    @contact = Contact.find(params[:contact_id])
    @contact.create_facebook_account
    flash[:notice] = "Freischaltcode erzeugt."
    redirect_to :back
  end

  # Löscht einen Facebook-Account in der Autohaus-Anwendung
  def destroy
    # Lösche nur, wenn
    # 1. von einem Admin aufgerufen oder
    # 2. von einem Facebook-User aufgerufen
    if request_comes_from_facebook? then
      # Wenn eine Verknüpfung von Facebook gelöscht werden soll, so muss
      # gesichert sein, dass die Applikation authentifiziert wurde
      if ensure_authenticated_to_facebook then
        @facebook_account = FacebookAccount.find_by_contact_id_and_uid(params[:contact_id], @facebook_session.user.uid)

        @facebook_account.destroy

        redirect_to :controller => 'facebook'
      end
    else
      # Wenn eine Verknüpfung aus dem Admin-Menü gelöscht werden soll, so muss
      # gesichert sein, dass dies von einem Admin erfolgt
      if require_admin then
        @facebook_account = FacebookAccount.find_by_contact_id_and_uid(params[:contact_id], params[:uid])

        @facebook_account.destroy
      end
    end
  end
end