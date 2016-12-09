require 'open-uri'
require 'nokogiri'

def get_meaning_name(name)
  url = "http://babynames.net/names/#{name}/"
  begin
    html_file = open(url)
    html_doc = Nokogiri::HTML(html_file)

    html_doc.search('.more-info p').each do |info|
      @info_name = info.text
      puts @info_name
    end
  rescue OpenURI::HTTPError => e
    if e.message == '404 Not Found'
      puts "no extra info available"
    else
      puts @info_name
    end
  end
end
