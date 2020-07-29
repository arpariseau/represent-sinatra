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

end
