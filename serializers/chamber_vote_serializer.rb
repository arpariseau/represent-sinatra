require '././poros/bill_aggregator'
require 'json'

class ChamberVoteSerializer

  def initialize(chamber)
    @aggregator = BillAggregator.new
    @chamber = chamber
  end

  def json_api
    JSON.pretty_generate({ data: find_chamber_votes })
  end

  def find_chamber_votes
    if @chamber == "house"
      return { house_vote: @aggregator.get_house_vote_info }
    elsif @chamber == "senate"
      return { senate_vote: @aggregator.get_senate_vote_info }
    else
      return { error: "No such chamber" }
    end
  end

end
