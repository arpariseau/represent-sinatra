require File.expand_path '../spec_helper.rb', __FILE__

describe "Accessing the image endpoint" do
  it "should get a url for a representative with an image" do
    get 'api/v1/images?congress_id=O000172'
    expect(last_response.body).to eq("https://theunitedstates.io/images/congress/450x550/O000172.jpg")
  end

  it "should get a default image for representatives without one" do
    get 'api/v1/images?congress_id=L000594'
    expect(last_response.body).to eq("https://www.aoc.gov/sites/default/files/styles/square_lg/public/6498851589_97e8060fc6_b.jpg?h=c4842d71&itok=YgC_mOaA")
  end
end
