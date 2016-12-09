class Name < ApplicationRecord
  has_and_belongs_to_many :origin

end
# create a simple form on the navbar
# specify on the simple form the url destination
# create with def search, the search method on pages controller
# create the view inside views/pages/search.html.erb
# specify the routes : post "search", to: "pages#search"
