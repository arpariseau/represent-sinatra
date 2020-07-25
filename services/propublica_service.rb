require 'faraday'
require '././config/config'

class PropublicaService
  def house_members
    get_json("/congress/v1/116/house/members.json")
  end

  def senators
    get_json("/congress/v1/116/senate/members.json")
  end

  private

  def conn
    Faraday.new(url: "https://api.propublica.org") do |faraday|
      faraday.headers["X-API-KEY"] = ENV["PROPUBLICA_API_KEY"]
    end
  end

  def get_json(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
end
