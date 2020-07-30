require '././services/propublica_service'

class BillAggregator

  def initialize
    @service = PropublicaService.new
  end

  def aggregate_bills
    house_votes = aggregate_house_bills
    senate_votes = aggregate_senate_bills
    house_votes.concat(senate_votes)
  end

  def aggregate_house_bills
    house_votes = @service.total_votes("O000172")
    num_votes = house_votes[:results].first[:roles].first[:total_votes]
    offset = 0
    bill_list = []
    while offset < num_votes
      votes = @service.member_vote("O000172", offset)[:results].first[:votes]
      votes.each do |vote|
        if vote[:question] == "On Passage" ||
           vote[:question] == "On Motion to Suspend the Rules and Pass"
          bill_list << filter_bill_info(vote, "house")
        end
      end
      offset += 20
    end
    bill_list
  end

  def aggregate_senate_bills
    senate_votes = @service.total_votes("S001191")
    num_votes = senate_votes[:results].first[:roles].first[:total_votes]
    offset = 0
    bill_list = []
    while offset < num_votes
      votes = @service.member_vote("S001191", offset)[:results].first[:votes]
      votes.each do |vote|
        if vote[:question] == "On Passage of the Bill"
          bill_list << filter_bill_info(vote, "senate")
        end
      end
      offset += 20
    end
    bill_list
  end

  def filter_bill_info(vote, chamber)
    bill_id = vote[:bill][:bill_id].chomp("-116")
    bill_vote_info = { (chamber + "_roll_call").to_sym => vote[:roll_call].to_i,
                       (chamber + "_session").to_sym => vote[:session].to_i }
    { bill_id.to_sym => bill_vote_info }
  end

end
