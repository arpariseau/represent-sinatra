require '././services/propublica_service'

class MemberVoteSerializer

  def initialize(member_id, json)
    @member_id = member_id
    @vote = json[:results][:votes][:vote]
  end

  def json_api
    {data: find_member_vote}.to_json
  end

  private

  def find_member_vote
    member_vote = { @vote[:roll_call] => nil }
    @vote[:positions].each do |congress|
      if congress[:member_id] = @member_id
        member_vote[@vote[:roll_call]] = congress[:vote_position]
      end
    end
    member_vote
  end
end
