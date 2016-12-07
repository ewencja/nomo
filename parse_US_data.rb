def import_US_names
#   #result = File.open('yob2015.txt')
#   #p result
#   #File.open('./yob2015.txt').each_line do |line|
# #    name = line[0]
#     gender = line[1]
#     frequency = line[2]
#
#   end
results = []
  File.open("yob2015.txt", "r") do |f|
    f.each_line do |line|
        result = line.split(",")
          results << {name: result[0], frequency: result[2].strip}
    end
  end
  results
end
