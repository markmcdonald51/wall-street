# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_investor_session',
  :secret      => 'e3a43f432b4de6f79201f83b843a0872b7df292129566712253dc5431704097c927dc4c63c6587b69efa52f12a05a0093e26da548746f5ddd692cb896c70f1de'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
