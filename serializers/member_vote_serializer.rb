require '././services/propublica_service'

class MemberVoteSerializer

  def initialize(json)
    @bill_votes = json[:results].first[:votes]
  end

  def json_api
    {data: clean_member_vote(@bill_votes)}.to_json
  end

  def clean_member_vote(bill_votes)
    votes_hash = {}
    bill_votes.each do |vote|
      votes_hash[vote[:roll_call]] = vote[:position]
    end 

    votes_hash
  end 
end