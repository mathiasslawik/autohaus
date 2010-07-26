class FacebookComment < ActiveRecord::Base
  belongs_to :order

  #Holt den Namen des Kommentators
  def username
    #Der Name
    session = Facebooker::Session.create()

    user = session.fql_query "SELECT name FROM user WHERE uid = '#{uid}'"

    unless user == nil || user.first == nil
      username = user.first.name
    else
      username = "Unbekannt"
    end
  end

  #Die möglichen Kunden, die diesen Kommentar gepostet haben könnten
  def possible_contacts
    accounts = FacebookAccount.find_all_by_uid uid

    if contacts.size > 0
      contact_names = accounts.collect { |account| account.contact.sort }

      contact_names.join(", ")
    else
      "Keine"
    end
  end
end