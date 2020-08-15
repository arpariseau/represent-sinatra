require File.expand_path '../spec_helper.rb', __FILE__

describe "Accessing the chamber vote endpoint" do
  it "should get the house votes" do
    get 'api/v1/chamber_votes?chamber=house'
    house_resp = JSON.parse(last_response.body)

    expect(house_resp["data"]).to have_key("house_vote")
    expect(house_resp["data"]["house_vote"].keys.first).to be_a String
    expect(house_resp["data"]["house_vote"].values.first).to be_an Integer
  end

  it "should get the senate votes" do
    get 'api/v1/chamber_votes?chamber=senate'
    sen_resp = JSON.parse(last_response.body)

    expect(sen_resp["data"]).to have_key("senate_vote")
    expect(sen_resp["data"]["senate_vote"].keys.first).to be_a String
    expect(sen_resp["data"]["senate_vote"].values.first).to be_an Integer
  end
end
