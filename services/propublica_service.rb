require 'faraday'
require '././config/config'

class PropublicaService
  def house_members
    get_json("/congress/v1/116/house/members.json")
  end

  def senators
    get_json("/congress/v1/116/senate/members.json")
  end

  def bills(bill_id)
    get_json("/congress/v1/116/bills/#{bill_id}.json")
  end

  def total_votes(member_id)
    get_json("/congress/v1/members/#{member_id}.json")
  end

  def member_vote(member_id, offset)
    get_json("/congress/v1/members/#{member_id}/votes.json", { offset: offset })
  end

  def roll_call_vote(chamber, session, roll_call)
    get_json("/congress/v1/116/#{chamber}/sessions/#{session}/votes/#{roll_call}.json")
  end

  private

  def conn
    Faraday.new(url: "https://api.propublica.org") do |faraday|
      faraday.headers["X-API-KEY"] = ENV["PROPUBLICA_API_KEY"]
    end
  end

  def get_json(url, params = nil)
    response = conn.get(url, params)
    JSON.parse(response.body, symbolize_names: true)
  end
end
