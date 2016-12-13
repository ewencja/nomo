class NamesController < ApplicationController

  # def soundex
  #   # @sample_soundex = Name.where(:gender => params[:gender]).sample(10)
  #   session.delete(gender) if session[:gender]
  #   session[:gender] = params[:gender]
  #   @sample_soundex = Name.where(:gender => session[:gender]).sample(5)
  #   # @sample_soundex = ["Anna", "Max", "Michelle", "Ewa"]
  #   session[:soundex_sample] = @sample_soundex
  #   cookies.delete :soundex if cookies[:soundex]
  #   redirect_to root_path
  # end
  #
  #
  # def selection
  #   cookies.signed[:soundex] = params[:soundex_names]
  #
  #   #FIXME names of countries/origin needs to be added - database!
  #   origin_names = []
  #   origins = Origin.all
  #   origins.each do |origin|
  #     origin_names << origin.origin
  #   end
  #   session[:origin_sample] = origin_names
  #   redirect_to root_path
  # end


  def name
    search_term = params[:name]
    @name = Name
      .where('lower(name) = ?', search_term.downcase)
      .first
    if !@name.nil?
      @origins = Origin.find_by_sql("SELECT o.origin FROM
        names n
        JOIN names_origins n_o ON n_o.name_id = n.id
        JOIN origins o ON n_o.origin_id = o.id
        WHERE LOWER(n.name) = LOWER('#{@name.name}')")
    end
  end

  def names_search
    gender = params[:gender]
    origin1 = params[:origin1]
    origin2 = params[:origin2]
    occurrence = params[:occurrence]
    length = params[:length]

    names = Name.find_by_sql [
      "SELECT names.*, origins.*
      FROM names
      JOIN names_origins
      	ON names_origins.name_id = names.id
      JOIN origins
      	ON names_origins.origin_id = origins.id
      WHERE (origins.origin = ? or origins.origin = ?) and names.gender = ?
        and names.occurence = ? and names.length = ? LIMIT 12",
      origin1, origin2, gender, occurrence, length]

    render json: names
  end

  def names
  end

end
