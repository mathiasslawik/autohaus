# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_autohaus_session',
  :secret      => '9323c9406f4641d5674031b0b223edf810ab97e613f38845f1a36f5003af9030d89b736ba8b0ac9a18ed9a8a900409d46c603b8df2c0c71169aaed7a527ab619'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
