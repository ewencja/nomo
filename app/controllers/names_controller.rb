class NamesController < ApplicationController

  def soundex
    # @sample_soundex = Name.where(:gender => params[:gender]).sample(10)
    session.delete(gender) if session[:gender]
    session[:gender] = params[:gender]
    @sample_soundex = Name.where(:gender => session[:gender]).sample(5)
    # @sample_soundex = ["Anna", "Max", "Michelle", "Ewa"]
    session[:soundex_sample] = @sample_soundex
    cookies.delete :soundex if cookies[:soundex]
    redirect_to root_path
  end


  def selection
    cookies.signed[:soundex] = params[:soundex_names]

    #FIX ME names of countries/origin needs to be added - database!
    origin_names = []
    origins = Origin.all
    origins.each do |origin|
      origin_names << origin.origin
    end
    session[:origin_sample] = origin_names
    redirect_to root_path
  end


  def name_search
    search_term = params[:searched_name]
    @found_name = Name.where(name: search_term)
    @origins = Origin.find_by_sql("SELECT o.origin FROM
      names n
      JOIN names_origins n_o ON n_o.name_id = n.id
      JOIN origins o ON n_o.origin_id = o.id
      WHERE n.name = '#{@found_name.first.name}'")
    # @origins = []
    # unless @found_name.empty?
    #   @found_name.each do |name|
    #    origin = Origin.where(origins.name_id: name.id)
    #    @origins << origin
     #end
   #end
  end


end
