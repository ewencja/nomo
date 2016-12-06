# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

name = [
  {
  name: "Max",
  gender: "masculine"
},
{
  name: "Anna",
  gender: "feminine"
}
]
name.each do |params|
  n = Name.create!(params)
end
