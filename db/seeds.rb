require 'text'
require_relative 'parse_wiki'
require_relative 'parse_us_census'

Name.destroy_all
Origin.destroy_all

wiki_names = parse_wiki(ARGV[1]) # [{ name: Ewa, origins: [French, Polish], ... }]
us_census_names = import_us_census(ARGV[2])

# Extract origins into string array
origins = Array.new
wiki_names.each do |name|
  name['origins'].each do |origin|
    origins << origin
  end
end
origins.uniq!

# Create origins in database
origin_lookup = Hash.new # { 'French': string => [[French]]: Origin }
origins.each do |origin|
  entry = Origin.create!({ origin: origin })
  origin_lookup[origin] = entry
end

# Add frequencies to names
us_census_names.each do |us_census_name|
  wiki_name = wiki_names.find{ |wiki_name|
    wiki_name['name'] == us_census_name[:name]
  }
  if !wiki_name.nil?
    wiki_name['frequency'] = us_census_name[:frequency]
  end
end

# Create names in database
wiki_names.each do |name|
  name['origins'] # ['French', 'Russian']
  origins = name['origins'].map do |origin|
    origin_lookup[origin]
  end
  Name.create({
    name: name['name'],
    gender: name['gender'],
    soundex: Text::Soundex.soundex(name['name']),
    metaphone: Text::Metaphone.metaphone(name['name']),
    double_metaphone: Text::Metaphone.double_metaphone(name['name']),
    origin: origins,
    frequency: name['frequency']
    })
end
