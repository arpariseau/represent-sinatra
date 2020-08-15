require File.expand_path '../spec_helper.rb', __FILE__

describe "Accessing the bills endpoint" do
  it "should get a bill" do
    get 'api/v1/bills'
    bill_resp = JSON.parse(last_response.body, symbolize_names: true)
    expect(bill_resp[:data].first).to have_key(:bill_id)
    expect(bill_resp[:data].first).to have_key(:short_title)
    expect(bill_resp[:data].first).to have_key(:primary_subject)
    expect(bill_resp[:data].first).to have_key(:summary_short)
    expect(bill_resp[:data].first).to have_key(:congress_url)
    expect(bill_resp[:data].first).to have_key(:house_roll_call)
    expect(bill_resp[:data].first).to have_key(:house_session)
    expect(bill_resp[:data].first).to have_key(:senate_roll_call)
    expect(bill_resp[:data].first).to have_key(:senate_session)
  end
end
