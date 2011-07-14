class ExternalCall < Sinatra::Base
  #  use Rack::Session::Cookie, :key => '_session_id',
  #    :secret => Rails.application.config.secret_token
  use ActionDispatch::Session::CookieStore

  register Sinatra::Async  

  get '/sinatra/local' do
    session[:demo] = "sinatra can write to Rails' session"
  end

  aget '/sinatra/goog' do
    session[:async_call]="async sinatra calls cannot write to Rails' session"
    make_async_req :get, "http://www.google.com/" do |http_callback|
      if http_callback
        session[:em_callback] = "this also isn't saving for me" 
      else
        headers 'Status' => '422'
      end
      async_schedule { redirect '/' }

    end
  end
  

  helpers do
    def make_async_req(method, host, opts={}, &block)
      opts[:head] = { 'Accept' => 'text/html', 'Connection' => 'keep-alive' }
      http = EM::HttpRequest.new(host)
      http = http.send(method, {:head => opts[:head], :body => {}, :query => {}})
      http.callback &block
    end
  end

end
