require 'date'

class RepresentativeSerializer

  def initialize(json)
    @house_reps = json[:results].first[:members]
  end

  def json_api
    {data: clean_each_rep(@house_reps)}.to_json
  end

  private

  def clean_each_rep(reps_array)
    reps_array.map do |rep|
      clean_rep_attributes(rep)
    end
  end

  def clean_rep_attributes(rep_hash)
    clean_hash = delete_unneeded_rep_attr(rep_hash)
    clean_hash[:govtrack_id] = clean_hash[:govtrack_id].to_i
    clean_hash[:district] = clean_hash[:district].to_i
    clean_hash[:last_updated] = clean_hash[:last_updated].to_datetime
    clean_hash[:dob] = clean_hash.delete(:date_of_birth)
    clean_hash[:congress_id] = clean_hash.delete(:id)
    clean_hash[:missed_votes_percentage] = clean_hash.delete(:missed_votes_pct)
    clean_hash[:votes_with_percentage] = clean_hash.delete(:votes_with_party_pct)
    clean_hash[:votes_without_party_percentage] = clean_hash.delete(:votes_against_party_pct)
    clean_hash
  end

  def delete_unneeded_rep_attr(rep_hash)
    unneeded_attr = [:title, :short_title, :api_uri, :middle_name, :suffix,
                   :youtube_account, :cspan_id, :votesmart_id, :icpsr_id,
                   :crp_id, :google_entity_id, :fec_candidate_id, :rss_url,
                   :ideal_point, :seniority, :next_election, :total_present,
                   :ocd_id, :fax, :geoid]
    rep_hash.delete_if {|key, value| unneeded_attr.include?(key)}
  end

end
