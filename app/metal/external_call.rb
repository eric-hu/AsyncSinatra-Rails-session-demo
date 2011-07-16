class ExternalCall < Sinatra::Base
#  use ActionDispatch::Session::CookieStore


  register Sinatra::Async  


  # use Sinatra's default session, which stores under the key "rack.session"
  # instead of "_session_id" like Rails uses
  enable :sessions

  aget '/sinatra/local' do
    session[:demo] = "sinatra can write to Rails' session"
  end

  aget '/sinatra/goog' do
    debugger
    session[:async_call]="Async-sinatra wrote this"
    make_async_req :get, "http://www.google.com/a" do |http_callback|
      if http_callback
        session[:em_callback] = "Async-sinatra wrote this after an external HTTP request"
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
      http.errback {|err| puts "Request failed :(\nReturn data: #{err}"}
    end
  

  
  end


end