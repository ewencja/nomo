class PagesController < ApplicationController
  def home
    @gender = ["boy", "girl", "unisex"]
    get_names_origin
    @length = ["short", "medium", "long"]
    # @result = find_gender
    # @result_first_letter = first_letter
  end

  def find_gender
    @masculine = Name.where(gender: "masculine")
    @feminine = Name.where(gender: "feminine")
  end

  # def first_letter
  #   name = Name.downcase
  #   @result_first_letter = Name.where(name.initial == "a")
  # end

  def get_names_origin
    @origin_names = []
    @origin = Origin.all
    @origin.each do |origin|
      @origin_names << origin.origin
    end
  end

  def results
  end

end
