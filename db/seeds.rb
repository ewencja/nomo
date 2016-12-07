require 'text'
require_relative '../parse'
require_relative '../parse_US_data'

Name.destroy_all
Origin.destroy_all

names = import_names() # [{ name: Ewa, origins: [French, Polish], ... }]

# Extract origins into string array
origins = Array.new
names.each do |name|
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

# Create names in database
names.each do |name|
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
    origin: origins
    })
end

# results = import_US_names
#
# results[0].each do |result|
#   if names.include? result
#     result


# Name.destroy_all

# names.each do |name|
  # puts single_name['name']
  # params = {
  #   name: single_name['name'],
  #   # origin: single_name['origin'],
  #   gender: single_name['gender']
  # }
#   Name.create!(name)
# end
