
# def import_us_census(path)
#   results = []
#
#   File.open(path, "r") do |f|
#     f.each_line do |line|
#       result = line.split(",")
#       results << {name: result[0], frequency: result[2].strip}
#     end
#   end
#   return results
# end

def import_us_census
  results = []

  Dir.glob("db/us_census/*.txt") do |my_text_file|
    # results_year = []
    puts "Parsing #{my_text_file}"
    year = my_text_file.split("/").last.split(".").first[3..99]
    File.open(my_text_file, "r").each do |f|
      f.each_line do |line|
        result = line.split(",")
        #puts "result"
        if result[1] == "F"
          result[1] = "feminine"
        elsif result[1] == "M"
          result[1] = "masculine"
        end
        results << {name: result[0], gender: result[1], frequency: result[2].strip, year: year}
      end
    end
  end
  return results
end
