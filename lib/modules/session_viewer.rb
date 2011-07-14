module SessionViewer
  # 7/15/2011: Mini helper module for viewing Rail's and Sinatra's default
  # sessions (within cookie)
  #
  # Doesn't work with redis-store based sessions.
  # Assumes Rails 3.1 using default session settings
  # and Sinatra uses "enable :sessions"
  #
  # autoload file into Rails environment by placing in lib/ folder (or any
  # subfolder) and adding the following to config/application.rb
  #
  # config.autoload_paths += Dir["#{config.root}/lib/**/"]
  #
  # "include SessionViewer" in classes
  #
  # OTHER NOTES: this can't be used in views, as they don't have access to the
  # env variable.  Instead, call this in the controller action prior to the view
  # and save it as a local variable, i.e. @sin_sess = get_sinatra_session

  # Decodes session string from base64 encoding (along with some character
  # encoding magic)
  # Source: http://pastie.org/235017
  def show_session(cookie)
    Marshal.load(Base64.decode64(CGI.unescape(cookie.split("\n").join).split('--').first))
  end

  # Rails session as a hash
  def get_rails_session
    # extract the key name that Rails uses
    rails_session_name = Rails.application.class.parent::Application.config.session_options[:key]
    show_session(env_cookie_hash[rails_session_name]) if env_cookie_hash[rails_session_name]
  end

  # Sinatra session as a hash
  def get_sinatra_session
    sinatra_session_name = env["rack.session.options"][:key]||"rack.session"
#    debugger
    show_session(env_cookie_hash["rack.session"]) if env_cookie_hash["rack.session"]
  end

  private
  def env_cookie_hash
    env["rack.request.cookie_hash"] || {}
  end
end