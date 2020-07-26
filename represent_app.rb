require 'sinatra'
require "sinatra/namespace"
require './services/propublica_service'
require './services/news_api_service'
require './serializers/representative_serializer'
require './serializers/senator_serializer'
require './serializers/article_serializer'
require 'pry'

namespace '/api/v1' do

  before do
    content_type 'application/json'
  end

  get '/' do
    "Sinatra's running!"
  end

  get '/representatives' do
    service = get_propublica
    json = service.house_members
    RepresentativeSerializer.new(json).json_api
  end

  get '/senators' do
    service = get_propublica
    json = service.senators
    SenatorSerializer.new(json).json_api
  end

  get '/articles' do 
    service = get_news_api

    favorite_names = params["favorite_names"]
    language_abbrev = params["language"]
    sort_by = params["sort"]
    num_results = params["num_results"]

    json = service.get_everything(favorite_names, language_abbrev, sort_by, num_results)
    ArticleSerializer.new(json).json_api
  end 
end

private

def get_propublica
  PropublicaService.new
end

def get_news_api
  NewsapiService.new
end
