require 'sinatra'
require "sinatra/namespace"
require './poros/bill_aggregator'
require './services/propublica_service'
require './services/news_api_service'
require './services/image_repo_service'
require './serializers/article_serializer'
require './serializers/bill_serializer'
require './serializers/chamber_vote_serializer'
require './serializers/member_vote_serializer'
require './serializers/representative_serializer'
require './serializers/senator_serializer'

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

    favorite_names = params[:favorite_names]
    language_abbrev = params[:language]
    sort_by = params[:sort]
    num_results = params[:num_results]

    json = service.get_everything(favorite_names, language_abbrev, sort_by, num_results)
    ArticleSerializer.new(json).json_api
  end

  get '/bills' do
    bill_list = BillAggregator.new.aggregate_bills
    BillSerializer.new(bill_list).json_api
  end

  get '/chamber_votes' do
    chamber = params[:chamber]

    api_data = ChamberVoteSerializer.new(chamber).json_api
    File.open("#{chamber}_votes.json", "w") do |f|
      f.write(api_data)
    end
  end

  get '/member_votes' do
    member_id = params[:member_id]
    chamber = params[:chamber]
    session = params[:session]
    roll_call = params[:roll_call]

    json = get_propublica.roll_call_vote(chamber, session, roll_call)
    MemberVoteSerializer.new(member_id, json).json_api
  end

  get '/images' do
    congress_id = params[:congress_id]

    get_image_repo.get_image(congress_id)
  end

end

private

def get_propublica
  PropublicaService.new
end

def get_news_api
  NewsapiService.new
end

def get_image_repo
  ImageRepoService.new
end
