class NoteApiService
  require 'net/http'
  require 'uri'
  require 'json'

  def self.fetch_creator_info(creator_id)
    url = URI.parse("https://note.com/api/v2/creators/#{creator_id}")
    res = Net::HTTP.get_response(url)
    JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
  end
end
