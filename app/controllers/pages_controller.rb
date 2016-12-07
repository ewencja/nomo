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
      origin = Origin.find_by(origin: params[:origin]).id
      @names = Name.where(gender: params[:gender]).joins(:names_origins).where(origin: origin)
      #origin.collect(&:origin).first
      raise
    else
      @names = Name.all
    end
  end

end
