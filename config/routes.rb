RailsEMtest::Application.routes.draw do
  root :to => "main#index"
  match '/sinatra/*action', :to => ExternalCall
end
