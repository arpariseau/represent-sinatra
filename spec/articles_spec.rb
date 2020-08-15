require File.expand_path '../spec_helper.rb', __FILE__

describe "Accessing the articles endpoint" do
  it "should get articles" do
    get 'api/v1/articles?language=en&sort=relevance&num_results=6&favorite_names="nancy pelosi,mitch mcconnell"'
    article_resp = JSON.parse(last_response.body, symbolize_names: true)
    expect(article_resp[:data].first).to have_key(:source)
    expect(article_resp[:data].first).to have_key(:title)
    expect(article_resp[:data].first).to have_key(:description)
    expect(article_resp[:data].first).to have_key(:url)
    expect(article_resp[:data].first).to have_key(:published_at)
  end
end
