class ApplicationController < ActionController::Base
  include SessionViewer
  protect_from_forgery

  before_filter {@sinatra_session = get_sinatra_session}
end
