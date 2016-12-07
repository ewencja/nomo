class PagesController < ApplicationController
  def home
    @result = find_gender
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




end
