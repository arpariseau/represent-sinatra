require 'sinatra'
require "sinatra/namespace"

namespace '/api/v1' do

  before do
    content_type 'application/json'
  end

  get '/representatives' do
    "This is where the representatives should be."
  end

  get '/senators' do

  end

end
