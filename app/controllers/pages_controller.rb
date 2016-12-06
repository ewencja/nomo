class PagesController < ApplicationController
  def home
    @result = find_gender
  end

  def find_gender
    @masculine = Name.where(gender: "masculine")
  end




end
