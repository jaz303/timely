# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_timely_session',
  :secret      => '38f79283ba929dcca3fe38ed7beeafddc85796c4e26416e726d54ce85892ff42773aed0a1a1cdbba38718fec024f2d842fc87f85a174bcc3ba0b078fe1d76c7f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
