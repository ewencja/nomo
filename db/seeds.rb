require 'text'
require_relative 'parse_wiki'
require_relative 'parse_us_census'


Origin.destroy_all
Frequency.destroy_all
Name.destroy_all

puts "Parsing wiki data"
wiki_names = parse_wiki(ARGV[1]) # [{ name: Ewa, origins: [French, Polish], ... }]

# puts "Parsing US census data"
us_census_names = import_us_census

puts "Extracting origins into string array"
# Extract origins into string array
origins = Array.new
wiki_names.each do |name|
  name['origins'].each do |origin|
    origins << origin
  end
end
origins.uniq!

puts "Creating origins in the database"
# Create origins in database
origin_lookup = Hash.new # { 'French': string => [[French]]: Origin }
origins.each do |origin|
  entry = Origin.create!({ origin: origin })
  origin_lookup[origin] = entry
end


puts "Creating names in database"
# Create names in database
new_names = Array.new
wiki_names.each do |name|
  puts "Creating name #{name['name']}"
  name['origins'] # ['French', 'Russian']

  origins = name['origins'].map do |origin|
    origin_lookup[origin]
  end

  if name['name'].length > 8
    length =  'long'
  elsif name['name'].length > 4
    length =  'medium'
  else
    length =  'short'
  end

  new_names << {
    name: name['name'],
    gender: name['gender'],
    soundex: Text::Soundex.soundex(name['name']),
    metaphone: Text::Metaphone.metaphone(name['name']),
    double_metaphone: Text::Metaphone.double_metaphone(name['name']),
    origin: origins,
    length: length
  }

end

puts "Inserting names into database"
created_names = Name.create(new_names)

puts "Indexing names into local hash"
created_names_hash = Hash.new
created_names.each do |name|
  created_names_hash[name[:name]] = name
end

puts "hash size #{created_names.size}"



# end

# name_Janette = Name.find(34118)
# name_Janette.destroy

#
# puts "Adding frequencies to names"
# # Add frequencies to names
# us_census_names.each do |us_census_name|
#     puts "Processing #{us_census_name[:year]}-#{us_census_name[:name]}"
#     new_name = Name.where(
#       :name => us_census_name[:name],
#       :gender => us_census_name[:gender]).first
#     if !new_name.nil?
#       Frequency.create({
#         name_id: new_name.id,
#         frequency: us_census_name[:frequency],
#         year: us_census_name[:year]
#         })
#     end
# end

puts "Adding frequencies to names"
# Add frequencies to names
Frequency.transaction do
  us_census_names.each do |us_census_name|
      puts "Processing #{us_census_name[:year]}-#{us_census_name[:name]}"
      new_name = Name.where(
        :name => us_census_name[:name],
        :gender => us_census_name[:gender]).first
      if !new_name.nil?
        Frequency.create({
          name_id: new_name.id,
          frequency: us_census_name[:frequency],
          year: us_census_name[:year]
        })
      end
  end
end
