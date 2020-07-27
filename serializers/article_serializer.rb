class ArticleSerializer

  def initialize(json)
    @articles = json[:articles]
  end

  def json_api
    {data: clean_each_article(@articles)}.to_json
  end

  private

  def clean_each_article(articles_array)
    articles_array.map do |article|
      clean_article_attributes(article)
    end
  end

  def clean_article_attributes(article_hash)
    clean_hash = {}
    clean_hash[:source] = article_hash[:source][:name]
    clean_hash[:title] = article_hash[:title]
    clean_hash[:description] = article_hash[:description]
    clean_hash[:url] = article_hash[:url]
    clean_hash[:published_at] = article_hash[:publishedAt]
    clean_hash
  end
end 