def import_us_census(path)

  results = []

  File.open(path, "r") do |f|
    f.each_line do |line|
      result = line.split(",")
      results << {name: result[0], frequency: result[2].strip}
    end
  end
  return results
end
