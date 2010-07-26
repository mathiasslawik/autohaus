class ContactsController < ApplicationController
  before_filter :require_admin

  def index
    #Übernimm Contact-Typ aus Params
    @contacts_class = params[:class] if params[:class]

    #Übernimm Contact-Typ aus Session, falls kein param vorhanden
    @contacts_class = session[:contacts_class] unless @contacts_class

    #Default: Contact-Typ = Person
    @contacts_class = "Person" unless @contacts_class

    #Frage alle Objekte aus Datenbank ab
    @contacts = (eval("#{@contacts_class}").find :all, :include => [:orders, :facebook_account])

    #Übernimm Sort-Parameter aus Params. Default: ID
    @sort = if params[:sort] then params[:sort] else "id" end
    
    @contacts.sort! { |a,b| eval "a.#{@sort} <=> b.#{@sort}" }

    unless params[:reverse] == nil
      @contacts.reverse!
    end

    @contacts = @contacts.paginate :page => params[:page]

    #Speichere Contacts-Typ in Session
    session[:contacts_class] = @contacts_class
  end

  def edit
    @contact = Contact.find(params[:id])

    unless @contact.facebook_account.nil? || @contact.facebook_account.uid.nil?
      @fb_information = FacebookInformation.find_by_uid(@contact.facebook_account.uid)

      #Suche die Posts des Nutzers
      @fb_comments = (FacebookComment.find_all_by_uid @contact.facebook_account.uid).reject { |comment| comment.order.contact_id != @contact.id }
    end
  end

  def update
    contact = Contact.find(params[:contact][:id])

    if contact.update_attributes(params[:contact]) then
      flash[:notice] = "Kontakt erfolgreich gespeichert."

      redirect_to contacts_url
    else
      flash[:notice] = "Beim Speichern des Kontakts sind leider Fehler aufgetreten"

      flash[:errors] = contact.errors

      redirect_to edit_contact_url(contact.id)
    end
  end

  #Verschickt eine Facebook-Nachricht an einen Kontakt
  def send_message
    flash[:notice] = "Nachricht versendet."

    redirect_to :back
  end
end