require 'faraday'
require '././config/config'

class NewsapiService

  def get_everything(favorite_names, language_abbrev, sort_by, num_results)

    params = { q: format_request(favorite_names), sortBy: sort_by, language: language_abbrev, pageSize: num_results}

    get_json("v2/everything", params)
  end 

  private

  def format_request(favorite_names)
    favorite_names.split(",").join('"OR"')  
  end

  def conn
    Faraday.new(url: "https://newsapi.org/") do |faraday|
      faraday.headers["X-Api-Key"] = ENV["NEWS_API_KEY"]
    end
  end

  def get_json(url, params = nil)
    response = conn.get(url, params) do |request|
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end 
