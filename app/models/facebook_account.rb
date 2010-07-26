class FacebookAccount < ActiveRecord::Base
  belongs_to :contact

#  after_destroy :remove_facebook_friends

  has_one :facebook_information, :foreign_key => :uid

  has_and_belongs_to_many :friends,
      :class_name => 'FacebookAccount',
      :join_table => 'facebook_friends',
      :foreign_key => 'uid',
      :association_foreign_key => 'friendof'

  def self.primary_key
    'uid'
  end

  # Bevor ein FacebookAccount erstellt wird, wird automatisch ein
  # Freischaltcode erzeugt
  def before_create
    # Schleife, damit keine zwei Facebook-Accounts mit dem gleichen Freischalt-
    # code erzeugt werden.
    while true
      self.token = generate_token
      account = FacebookAccount.find_by_token self.token
      break if account == nil
    end
  end

  # Nachdem ein Account gelöscht wurde, müssen auch die Freunde-Verknüpfungen
  # gelöscht werden
#  def remove_facebook_friends(record)
#    sql = FacebookAccount.connection()
#    sql.execute "SET autocommit=0";
#    sql.begin_db_transaction
#    sql.execute("DELETE FROM facebook_friends WHERE friendof = #{record.uid}");
#    sql.execute("DELETE FROM facebook_friends WHERE uid = #{record.uid}")
#    sql.commit_db_transaction
#  end

  private

  # Erzeugt einen Freischaltcode für einen Facebook-Benutzer
  def generate_token
    password_chars = ("a".."z").to_a + ("0".."9").to_a

    token = ""

    1.upto(8) { |i| token << password_chars[rand(password_chars.size-1)] }

    token
  end
end