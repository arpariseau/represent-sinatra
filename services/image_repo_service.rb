require 'faraday'
require '././config/config'

class ImageRepoService

  def get_image(congress_id)
    return_image = conn.get("images/congress/450x550/#{congress_id}.jpg")
    if return_image.status == 404
      "https://www.aoc.gov/sites/default/files/styles/square_lg/public/6498851589_97e8060fc6_b.jpg?h=c4842d71&itok=YgC_mOaA"
    else
      "https://theunitedstates.io/images/congress/450x550/#{congress_id}.jpg"
    end
  end

  private

  def conn
    Faraday.new(url: "https://theunitedstates.io/")
  end
end
