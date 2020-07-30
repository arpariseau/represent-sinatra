class BillSerializer

  def initialize(bill_list)
    @bills = bill_list
  end

  def json_api
    {data: compile_bill_list}.to_json
  end

  private

  def compile_bill_list
    service = PropublicaService.new
    find_most_recent_votes
    clean_list = separate_duplicates.concat(merge_duplicates)
    clean_list.map do |bill|
      results = service.bills(bill.keys.first)[:results].first
      clean_bill_attributes(results, bill.values.first)
    end
  end

  def find_duplicates
    bill_ids = @bills.map { |bill| bill.keys.first }
    bill_ids.find_all { |bill| bill_ids.count(bill) > 1 }
  end

  def separate_duplicates
    solo_bills = @bills.clone
    solo_bills.delete_if { |bill| find_duplicates.include?(bill.keys.first) }
  end

  def merge_duplicates
    hr_s_bills = @bills.find_all { |bill| find_duplicates.include?(bill.keys.first) }
    sorted_bills = hr_s_bills.sort_by { |bill| bill.keys.first }
    merged_bills = []
    sorted_bills.each_cons(2) do |first_bill, second_bill|
      bill_id = first_bill.keys.first
      if bill_id == second_bill.keys.first &&
         first_bill[bill_id].keys != second_bill[bill_id].keys
        merged_bills << { bill_id => first_bill[bill_id].merge(second_bill[bill_id])}
      end
    end
    merged_bills
  end

  def clean_bill_attributes(bill_info, bill_hash)
    needed_attr = [:bill_id, :summary_short, :short_title,
                   :congressdotgov_url, :primary_subject]
    bill_info.delete_if {|key, value| !needed_attr.include?(key)}
    bill_info[:congress_url] = bill_info.delete(:congressdotgov_url)
    bill_info[:senate_roll_call] = bill_hash[:senate_roll_call]
    bill_info[:senate_offset] = bill_hash[:senate_offset]
    bill_info[:house_roll_call] = bill_hash[:house_roll_call]
    bill_info[:house_offset] = bill_hash[:house_offset]
    bill_info
  end

  def find_most_recent_votes
    bill_ids = @bills.map { |bill| bill.keys.first }
    multi_votes = bill_ids.find_all { |bill| bill_ids.count(bill) > 2 }
    multi_bills = find_all_multi_vote_bills(multi_votes)
    indexes = @bills.each_index.select do |index|
      multi_votes.include?(@bills[index].keys.first)
    end
    most_recent_house = multi_bills.max_by { |bill| bill.values.first[:house_roll_call] }
    most_recent_senate = multi_bills.max_by { |bill| bill.values.first[:senate_roll_call] }
    indexes.each do |index|
      if @bills[index].values.first[:house_roll_call] !=
         most_recent_house.values.first[:house_roll_call] &&
         @bills[index].values.first[:senate_roll_call] !=
         most_recent_senate.values.first[:senate_roll_call]
           @bills.delete_at(index)
      elsif @bills[index].values.first[:house_roll_call] == 0
        @bills[index].values.first.delete(:house_roll_call)
      elsif @bills[index].values.first[:senate_roll_call] == 0
        @bills[index].values.first.delete(:senate_roll_call)
      end
    end
  end

  def find_all_multi_vote_bills(multi_vote_ids)
    multi_bills = @bills.find_all { |bill| multi_vote_ids.include?(bill.keys.first) }
    multi_bills.each do |bill|
      unless bill.values.first.has_key?(:house_roll_call)
        bill.values.first[:house_roll_call] = 0
      end
      unless bill.values.first.has_key?(:senate_roll_call)
        bill.values.first[:senate_roll_call] = 0
      end
    end
  end

end
