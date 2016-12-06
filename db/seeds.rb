# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# require the file that you created
# create variable

# results = parsing()

require_relative '../parse'

names = import_names()

Rails.logger.debug(names.size)

# name = [
#   {
#   name: "Max",
#   gender: "masculine"
# },
# {
#   name: "Anna",
#   gender: "feminine"
# }
# ]
names.each do |single_name|
  # puts single_name['name']
  params = {
    name: single_name['name'],
    # origin: single_name['origin'],
    gender: single_name['gender']
  }
  n = Name.create!(params)
end
