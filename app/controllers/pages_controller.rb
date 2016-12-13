require 'open-uri'
require 'nokogiri'

class PagesController < ApplicationController
  def gender
    @gender = ["masculine", "feminine", "unisex"]
  end

  # def home
  #   @gender = ["masculine", "feminine", "unisex"]
  #   @length = ["short", "medium", "long"]
  # end
  #
  # def results
  #   @names = Name.find_by_sql("SELECT b.name, b.gender
  #       FROM names n
  #       JOIN names_origins n_o
  #       	ON n_o.name_id = n.id
  #       JOIN origins o
  #       	ON n_o.origin_id = o.id
  #       JOIN names b
  #       	ON n.metaphone = b.metaphone and n.gender = b.gender
  #       WHERE (o.origin = '#{params[:origin0]}' or o.origin = '#{params[:origin1]}') and n.gender = '#{session[:gender]}' and n.name = '#{cookies[:soundex][0]}'").sample(7)
  # end
  #
  # def reset_session
  #   session.clear
  #   redirect_to root_path
  # end

  def frequency_by_name
    @output = ActiveRecord::Base.connection.execute("
      SELECT f.year, f.frequency
      FROM frequencies f
      JOIN names n
      ON n.id = f.name_id
      WHERE LOWER(n.name) = LOWER('#{params[:name]}')")
    render json: @output
  end

end
