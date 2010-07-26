class FacebookInformation < ActiveRecord::Base
  belongs_to :facebook_account, :foreign_key => :uid

  def self.primary_key
    'uid'
  end

  def self.update_from_facebooker_user(fb_user)
    information = FacebookInformation.find_by_uid(fb_user.uid)

    unless information
      information = FacebookInformation.new
      information.uid = fb_user.uid
    end
    
    unless fb_user.birthday_date.nil? then information.birthday = Date.parse(fb_user.birthday_date) end
    unless fb_user.hometown_location.nil? then information.hometown_location_city = fb_user.hometown_location.city end
    unless fb_user.music.nil? then information.music = fb_user.music end
    unless fb_user.pic_big.nil? then information.pic = fb_user.pic_big end
    unless fb_user.quotes.nil? then information.quotes = fb_user.quotes end
    unless fb_user.tv.nil? then information.tv = fb_user.tv end
    unless fb_user.affiliations.nil? then
      work = fb_user.affiliations.find{|a| a.type == 'work'}
      
      information.affiliations_work_name = work.name unless work == nil
    end
    unless fb_user.email.nil? then information.email = fb_user.email end

    information.save!
  end
end