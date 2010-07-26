class UserMessage < ActionMailer::Base
  
  def user_message(fb_user, message, subject, sent_at = Time.now)
    facebook_accounts = FacebookAccount.find_all_by_uid fb_user.uid
    contacts = []

    facebook_accounts.each { |account| contacts << account.contact unless account.contact.nil? }

    subject    "Neue Nachricht von #{fb_user.name}. Betreff: #{subject}"
    recipients "autohaus@matzelworkz.de"
    from       "#{fb_user.email}"
    sent_on    sent_at
    content_type "text/html"
    body       :fb_user => fb_user, :message => message, :contacts => contacts
  end

end
