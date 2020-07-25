require 'sinatra'
require "sinatra/namespace"
require './services/propublica_service'
require 'pry'

namespace '/api/v1' do

  before do
    content_type 'application/json'
  end

  get '/representatives' do
    service = get_propublica
    json = service.house_members
    binding.pry
    RepresentativeSerializer.new(json)
  end

  get '/senators' do
    service = get_propublica
    service.senators
    binding.pry
    SenatorSerializer.new(json)
  end
end

private

def get_propublica
  PropublicaService.new
end
