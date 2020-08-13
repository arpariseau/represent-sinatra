require '././services/propublica_service'

class BillAggregator

  def initialize
    @service = PropublicaService.new
    @house_vote_types = {}
    @senate_vote_types = {}
  end

  def aggregate_bills
    house_votes = aggregate_house_bills
    senate_votes = aggregate_senate_bills
    house_votes.concat(senate_votes)
  end

  def get_house_vote_info
    aggregate_house_bills
    @house_vote_types
  end

  def get_senate_vote_info
    aggregate_senate_bills
    @senate_vote_types
  end

  def aggregate_house_bills
    house_votes = @service.total_votes("O000172")
    num_votes = house_votes[:results].first[:roles].first[:total_votes]
    offset = 0
    bill_list = []
    while offset < num_votes
      votes = @service.member_vote("O000172", offset)[:results].first[:votes]
      votes.each do |vote|
        bill_list << gather_house_topics(vote)
      end
      offset += 20
    end
    bill_list.compact
  end

  def aggregate_senate_bills
    senate_votes = @service.total_votes("S001191")
    num_votes = senate_votes[:results].first[:roles].first[:total_votes]
    offset = 0
    bill_list = []
    while offset < num_votes
      votes = @service.member_vote("S001191", offset)[:results].first[:votes]
      votes.each do |vote|
        bill_list << gather_senate_topics(vote)
      end
      offset += 20
    end
    bill_list.compact
  end

  def filter_bill_info(vote, chamber)
    bill_id = vote[:bill][:bill_id].chomp("-116")
    bill_vote_info = { (chamber + "_roll_call").to_sym => vote[:roll_call].to_i,
                       (chamber + "_session").to_sym => vote[:session].to_i }
    { bill_id.to_sym => bill_vote_info }
  end

  def gather_house_topics(vote)
    filter_house_topics(vote[:question])
    if vote[:question].include?("Pass")
      filter_bill_info(vote, "house")
    else
      nil
    end
  end

  def gather_senate_topics(vote)
    if @senate_vote_types.has_key?(vote[:question])
      @senate_vote_types[vote[:question]] += 1
    else
      @senate_vote_types[vote[:question]] = 1
    end
    if vote[:question] == "On Passage of the Bill"
      filter_bill_info(vote, "senate")
    else
      nil
    end
  end

  def filter_house_topics(question)
    if question.include?("Pass")
      aggregate_house_topics("On Passage")
    elsif question.downcase.include?("commit") && !question.include?("Committee")
      aggregate_house_topics("On Motion to Commit/Recommit with Instructions")
    elsif question.include?("Agree") && question.include?("Amend")
      aggregate_house_topics("On Agreeing to the Amendment")
    elsif question.include?("Ordering")
      aggregate_house_topics("On Ordering the Previous Question")
    elsif question.include?("Resolution")
      aggregate_house_topics("On Agreeing to the Resolution")
    elsif question.include?("Concur")
      aggregate_house_topics("On Motion to Concur in the Senate Amendment(s)")
    elsif question.include?("Table")
      aggregate_house_topics("On Motion to Table")
    elsif question.include?("Call")
      aggregate_house_topics("Call to Order")
    else
      aggregate_house_topics(question)
    end
  end

  def aggregate_house_topics(key)
    if @house_vote_types.has_key?(key)
      @house_vote_types[key] += 1
    else
      @house_vote_types[key] = 1
    end
  end
end
