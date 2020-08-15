require File.expand_path '../spec_helper.rb', __FILE__

describe "Accessing the representatives endpoint" do
  it "should get a representative" do
    get 'api/v1/representatives'
    rep_resp = JSON.parse(last_response.body, symbolize_names: true)
    expect(rep_resp[:data].first).to have_key(:first_name)
    expect(rep_resp[:data].first).to have_key(:last_name)
    expect(rep_resp[:data].first).to have_key(:congress_id)
    expect(rep_resp[:data].first).to have_key(:dob)
    expect(rep_resp[:data].first).to have_key(:gender)
    expect(rep_resp[:data].first).to have_key(:party)
    expect(rep_resp[:data].first).to have_key(:leadership_role)
    expect(rep_resp[:data].first).to have_key(:twitter_account)
    expect(rep_resp[:data].first).to have_key(:facebook_account)
    expect(rep_resp[:data].first).to have_key(:govtrack_id)
    expect(rep_resp[:data].first).to have_key(:url)
    expect(rep_resp[:data].first).to have_key(:contact_form)
    expect(rep_resp[:data].first).to have_key(:cook_pvi)
    expect(rep_resp[:data].first).to have_key(:dw_nominate)
    expect(rep_resp[:data].first).to have_key(:total_votes)
    expect(rep_resp[:data].first).to have_key(:missed_votes)
    expect(rep_resp[:data].first).to have_key(:last_updated)
    expect(rep_resp[:data].first).to have_key(:office)
    expect(rep_resp[:data].first).to have_key(:phone)
    expect(rep_resp[:data].first).to have_key(:state)
    expect(rep_resp[:data].first).to have_key(:district)
    expect(rep_resp[:data].first).to have_key(:at_large)
    expect(rep_resp[:data].first).to have_key(:missed_votes_percentage)
    expect(rep_resp[:data].first).to have_key(:votes_with_percentage)
    expect(rep_resp[:data].first).to have_key(:votes_without_party_percentage)
  end
end
