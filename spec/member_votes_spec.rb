require File.expand_path '../spec_helper.rb', __FILE__

describe "Accessing the member vote endpoint" do
  it "gets the member's vote" do
    get 'api/v1/member_votes?member_id=S001191&chamber=senate&roll_call=185&session=1'
    vote_resp = JSON.parse(last_response.body)
    expect(vote_resp["data"]["185"]).to eq("Yes")
  end
end
