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
#    debugger
   
    # #res = make_async_req :get, "www.google.com", {} do |http_callback|
    make_async_req :get, "http://www.google.com/" do |http_callback|
#      debugger
      if http_callback
        session[:em_callback] = "this also isn't saving for me" 
        #        redirect '/main/index'
      else
        headers 'Status' => '422'
      end
      async_schedule { redirect '/' }

    end
  end


  helpers do

    def make_async_req(method,host,opts={}, &block)
      opts[:head] ||= {}
      opts[:body] ||= {}
      opts[:query] ||= {}

      opts[:head].merge!({ 'Accept' => 'application/json', 'Connection' => 'keep-alive' })

      http = EM::HttpRequest.new(host)

      http = http.send(method, {:head => opts[:head], :body => opts[:body].to_param, :query => opts[:query]})

      http.callback &block
    end
  end

end
