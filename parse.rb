#!/usr/bin/env ruby

require 'nokogiri'

# Iron out different spellings of infobox keys
#
# key - The String to be cleansed
#
# Examples
#
#   simplify_key("imagesiz e")
#   # => "imagesize"
#
#   simplify_key("   language")
#   # => "language"
#
#   simplify_key("Language")
#   # => "language"
#
# Returns the cleansed key
def simplify_key(key)
  key.downcase.gsub(/[^a-z]/, '')
end


# Parse a line of an infobox
#
# line - The String containing Wiki markup
#
# Examples
#
#   parse_infobox_line("| gender = Male")
#   # => "gender", "male"
#
# Returns a key, value pair
def parse_infobox_line(line)
  if match = line.match(/^\s*\|\s*(.*?)\s*\=\s*(.*?)\s*$/) then
    key, value = match.captures
    return simplify_key(key), value
  end
end


# Transform infobox content to hash
#
# lines - The String Array of infobox lines
#
# Returns a hash with key=>properties of infobox
def parse_infobox_lines(lines)
  properties = Hash.new
  lines.each do | line |
    key, value = parse_infobox_line(line)
    if !key.nil? && !value.empty? then
      properties[key] = value
    end
  end
  return properties
end


# Transform inner infobox wiki markup into hash
#
# text - The String containing infobox wiki markup
#
# Returns a hash with key=>properties of infobox
def parse_infobox(text)
  text.nil? ?
    parse_infobox_lines(Array.new) :
    parse_infobox_lines(text.split("\n"));
end


# Extract and parse infobox wiki markup into hash
#
# body - The String containing wiki page content
#
# Returns a hash with key=>properties of infobox
def extract_info_box(body)
  text = body[/{{Infobox given name[0-9]*(.*?)^}}/m, 1]
  parse_infobox(text)
end

def is_gender(s)
  return ['Feminine', 'Masculine', 'Unisex'].include?(s);
end

# Parse category from wiki markup into origin string
#
# text - The String containing category wiki markup
#
# Returns origin, gender
def parse_category(text)

  if match = text.match(/^\[\[Category\:(.*?) (.*?) given names\]\]$/)

    origin, gender = match.captures
    return origin, gender

  elsif match = text.match(/^\[\[Category\:(.*?) given names\]\]$/)

    match = match.captures[0]

    if is_gender(match)
      return nil, match
    else
      return match, nil
    end

  end

end

# Extract and parse categories wiki markup into list
#
# body - The String containing wiki page content
#
# Returns list of origins, genders
def extract_origins_genders(body)
  origins = Array.new
  genders = Array.new
  matches = body.scan(/\[\[Category\:.* given names\]\]/)
  matches.each do |match|

    origin, gender = parse_category(match)

    if !origin.nil?
      origins << origin
    end

    if !gender.nil?
      genders << gender
    end

  end
  return origins.uniq, genders.uniq
end


# Extract information from wiki page
#
# body - The String containing wiki page content
#
# Returns
#   is_redirect - The page only redirects, has no body
#   infobox - Infobox hash extracted from body
#   body - Text body, excluding infobox
def extract_components(body)

  # Wiki redirect pages begin with "#REDIRECT"
  is_redirect = (/^#REDIRECT.*/m =~ body) == 0;

  # Extract and parse infobox, remove after
  infobox = extract_info_box(body)
  body.gsub!(/{{Infobox.*?^}}/m, '')

  # Extract categories
  origins, genders = extract_origins_genders(body)

  return is_redirect, infobox, origins, genders, body

end


# Extract and process wiki pages from category export
# TODO Complete
#
# doc - The Nokogiri XML instance of category XML export
def parse_pages(doc)

  names = Hash.new

  doc.xpath('//xmlns:page').each do | page |

    name = page.xpath('xmlns:title').text.gsub(/\s\(.*/, '')
    body = page.xpath('xmlns:revision/xmlns:text').text

    is_redirect, infobox, origins, genders, body = extract_components(body)

    puts "\n#{name} #{origins} #{genders}"

    name_data = infobox;
    name_data['name'] = name
    name_data['is_redirect'] = is_redirect
    name_data['body'] = body

    names[name] = name_data

  end

  puts "Extracted #{names.size} names"

end



#################################################
# Initiate import
#################################################

if ARGV[0].nil? then

  # User didn't supply input filename
  puts "ERROR: Please enter path to XML Wikipedia Category export"
  puts exit 1

elsif !File.file?(ARGV[0]) then

  # Input file does not exist
  puts "ERROR: File \"#{ARGV[0]}\" not found"
  puts exit 2

else

  # Read and process input file
  doc = Nokogiri::XML(File.read(ARGV[0]));
  parse_pages(doc)

end
