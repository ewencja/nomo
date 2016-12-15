require 'text'
require_relative 'parse_wiki'
require_relative 'parse_us_census'

ActiveRecord::Base.connection.execute("TRUNCATE NAMES, FREQUENCIES, ORIGINS RESTART IDENTITY")

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

  if name['name'] == "Susanne"
    description = "Derived from the Hebrew Soshana, a derivative of shōshannāh and means lily or a rose."
  elsif name['name'] == "Grete"
    description = "Short form of Margarete. From the Greek Margarītēs, which is derived from maragon (a pearl)."
  elsif name['name'] == "Marcelino"
    description = "Form of the Latin Marcellus. The meaning of the name is Young Warrior."
  elsif name['name'] == "Helton"
    description = "A surname of Anglo-Saxon origin. It is derived from the family that lived in the village of Elton in Cheshire, England. The motto is Artibus et armis."
  elsif name['name'] == "Grace"
    description = "Inspired by grace (eloquence or beauty of form, kindness, mercy, favor), which is derived from the Latin gratia (favor, thanks). The name was made popular by 17th-century Puritans, who bestowed it in reference to God's favor and love toward mankind."
  elsif name['name'] == "Alan"
    description = "A Celtic  name. In Celtic the meaning of the name is: Harmony, stone, or noble. Also fair and handsome. Originally a saint's name, it was reintroduced to Britain during the Norman Conquest."
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
    length: length,
    description: description
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

      name = Name.where(
        :name => us_census_name[:name],
        :gender => us_census_name[:gender]).first

      if us_census_name[:year] == '2015' && !name.nil?
        occurence = nil;
        frequency = us_census_name[:frequency].to_i
        if frequency > 2000
          occurence = 'common'
        elsif frequency > 200
          occurence = 'moderate'
        elsif frequency > 10
          occurence = 'rare'
        else
          occurence = 'very rare'
        end
        name.update(:occurence => occurence)
      end

      if !name.nil?
        Frequency.create({
          name_id: name.id,
          frequency: us_census_name[:frequency],
          year: us_census_name[:year]
        })
      end

  end
end

puts "Filling names to moderate"
Name.where(:occurence => nil).each do |name|
  name.update(:occurence => 'rare')
end
