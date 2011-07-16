# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

require 'async-rack'

use Rack::Reloader if Rails.env.development?

run RailsEMtest::Application
