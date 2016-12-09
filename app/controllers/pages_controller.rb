require 'open-uri'
require 'nokogiri'

class PagesController < ApplicationController
  def home
    @gender = ["masculine", "feminine", "unisex"]
    get_names_origin
    @length = ["short", "medium", "long"]
    # @result = find_gender
    # @result_first_letter = first_letter
  end

  def get_names_origin
    @origin_names = []
    @origin = Origin.all
    @origin.each do |origin|
      @origin_names << origin.origin
    end
  end

  def results
    if params[:gender].present? || params[:origin].present?
      @names = Name
        .joins(:origin)
        .where(
          'names.gender' => params[:gender],
          'origins.origin' => [params[:origin0], params[:origin1]]);
    else
      @names = Name.all
    end
  end

  def search_for_name


  end

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
end
