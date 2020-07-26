class SenatorSerializer

  def initialize(json)
    @senators = json[:results].first[:members]
  end

  def json_api
    {data: clean_each_sen(@senators)}.to_json
  end

  private

  def clean_each_sen(sens_array)
    sens_array.map do |sen|
      clean_sen_attributes(sen)
    end
  end

  def clean_sen_attributes(sen_hash)
    clean_hash = delete_unneeded_sen_attr(sen_hash)
    clean_hash[:govtrack_id] = clean_hash[:govtrack_id].to_i
    clean_hash[:dob] = clean_hash.delete(:date_of_birth)
    clean_hash[:congress_id] = clean_hash.delete(:id)
    clean_hash[:missed_votes_percentage] = clean_hash.delete(:missed_votes_pct)
    clean_hash[:votes_with_percentage] = clean_hash.delete(:votes_with_party_pct)
    clean_hash[:votes_without_party_percentage] = clean_hash.delete(:votes_against_party_pct)
    clean_hash
  end

  def delete_unneeded_sen_attr(sen_hash)
    unneeded_attr = [:title, :short_title, :api_uri, :middle_name, :suffix,
                     :youtube_account, :cspan_id, :votesmart_id, :icpsr_id,
                     :crp_id, :google_entity_id, :fec_candidate_id, :rss_url,
                     :cook_pvi, :ideal_point, :seniority, :total_present,
                     :ocd_id, :fax, :lis_id]
    sen_hash.delete_if {|key, value| unneeded_attr.include?(key)}
  end

end
