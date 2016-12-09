require 'open-uri'
require 'nokogiri'

class PagesController < ApplicationController
  def gender
    @gender = ["masculine", "feminine", "unisex"]
  end

  # def soundex
  # end

  def home
    @gender = ["masculine", "feminine", "unisex"]
    # get_names_origin
    @length = ["short", "medium", "long"]
    # @result = find_gender
    # @result_first_letter = first_letter
  end
  #
  # def get_names_origin
  #   @origin_names = []
  #   @origin = Origin.all
  #   @origin.each do |origin|
  #     @origin_names << origin.origin
  #   end
  # end



  def results
#     if session[:gender].present? || params[:origin0].present? || params[:origin1].present? || params[:length].present?
      # @names = Name
      #   .joins(:origin)
      #   .where(
      #     'names.gender' => session[:gender],
      #     'names.length' => params[:length],
      #     'origins.origin' => [params[:origin0], params[:origin1]]);
      @names = Name.find_by_sql("SELECT b.name
          FROM names n
          JOIN names_origins n_o
          	ON n_o.name_id = n.id
          JOIN origins o
          	ON n_o.origin_id = o.id
          JOIN names b
          	ON left(n.name, 1) = left(b.name, 1) and right(n.name, 1) = right(b.name, 1) and length(n.metaphone) = length(b.metaphone) and n.gender = b.gender
          WHERE (o.origin = '#{params[:origin0]}' or o.origin = '#{params[:origin1]}') and n.gender = '#{session[:gender]}'").sample(7)
    # else
    #   @names = Name.all
    # end

  end

  def reset_session
    session.clear
    redirect_to root_path

  end

  # def search_for_name
  #   a = "Anna" #this name has a metaphone index
  #   b = "Alicia" #this name has a metaphone index
  #
  #   @soundex_names = Name.find_by_sql("SELECT b.name, b.metaphone from NAMES a
  #     JOIN NAMES b
  #     ON left(a.name, 1) = left(b.name, 1) and right(a.name, 1) = right(b.name, 1) and length(a.metaphone) = length(b.metaphone)
  #     WHERE a.name = '#{a}' or a.name = '#{b}'")
  # end

  #
  # def search_for_name
  #   # @sample = Name.where(:gender => params[:gender]).sample(10)
  #   a = "Isabella" #this name has a metaphone index
  #   b = "Alicia" #this name has a metaphone index
  #   soundex_names = Name.where(
  #     :metaphone => a[:metaphone])
  #   p soundex_names
  # end
  # search_for_name

# def get_meaning_name(name)
#   # begin
#   #   html_file = open(url)
#   #   html_doc = Nokogiri::HTML(html_file)

#   #   html_doc.search('.more-info p').each do |info|
#   #     @info_name = info.text
#   #     puts @info_name
#   #   end
#   # rescue OpenURI::HTTPError => e
#   #   if e.message == '404 Not Found'
#   #     puts "no extra info available"
#   #   else
#   #     puts @info_name
#   #   end
#   # end
# end

# helper_method :get_meaning_name

  # def display_soundex_names
  #
  # end


end
