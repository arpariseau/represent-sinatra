require File.expand_path '../spec_helper.rb', __FILE__

describe "Accessing the senators endpoint" do
  it "should get a senator" do
    get 'api/v1/senators'
    sen_resp = JSON.parse(last_response.body, symbolize_names: true)
    expect(sen_resp[:data].first).to have_key(:first_name)
    expect(sen_resp[:data].first).to have_key(:last_name)
    expect(sen_resp[:data].first).to have_key(:congress_id)
    expect(sen_resp[:data].first).to have_key(:dob)
    expect(sen_resp[:data].first).to have_key(:gender)
    expect(sen_resp[:data].first).to have_key(:party)
    expect(sen_resp[:data].first).to have_key(:leadership_role)
    expect(sen_resp[:data].first).to have_key(:twitter_account)
    expect(sen_resp[:data].first).to have_key(:facebook_account)
    expect(sen_resp[:data].first).to have_key(:govtrack_id)
    expect(sen_resp[:data].first).to have_key(:url)
    expect(sen_resp[:data].first).to have_key(:contact_form)
    expect(sen_resp[:data].first).to have_key(:dw_nominate)
    expect(sen_resp[:data].first).to have_key(:next_election)
    expect(sen_resp[:data].first).to have_key(:total_votes)
    expect(sen_resp[:data].first).to have_key(:missed_votes)
    expect(sen_resp[:data].first).to have_key(:last_updated)
    expect(sen_resp[:data].first).to have_key(:office)
    expect(sen_resp[:data].first).to have_key(:phone)
    expect(sen_resp[:data].first).to have_key(:state)
    expect(sen_resp[:data].first).to have_key(:senate_class)
    expect(sen_resp[:data].first).to have_key(:state_rank)
    expect(sen_resp[:data].first).to have_key(:missed_votes_percentage)
    expect(sen_resp[:data].first).to have_key(:votes_with_percentage)
    expect(sen_resp[:data].first).to have_key(:votes_without_party_percentage)
  end
end
