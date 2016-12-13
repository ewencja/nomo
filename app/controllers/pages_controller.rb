require 'open-uri'
require 'nokogiri'

class PagesController < ApplicationController
  def gender
    @gender = ["masculine", "feminine", "unisex"]
  end


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
