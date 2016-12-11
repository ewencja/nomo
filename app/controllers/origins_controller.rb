class OriginsController < ApplicationController

  def origins
    @origin_names = []
    origins = Origin.where("LOWER(origin) LIKE '%#{params[:origin].downcase}%'")
    origins.each do |origin|
      @origin_names << origin.origin
    end
    render json: @origin_names
  end

end
