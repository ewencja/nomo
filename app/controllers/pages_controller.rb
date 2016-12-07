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

end
