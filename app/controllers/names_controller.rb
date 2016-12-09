class NamesController < ApplicationController

  def soundex
     #@sample_soundex = Name.where(:gender => params[:gender]).sample(10)
      @sample_soundex = ["Anna", "Max", "Michelle", "Ewa"]
      session[:gender] = params[:gender]
      session[:soundex_sample] = @sample_soundex
      redirect_to root_path
  end


  def selection

    session[:soundex] = params[:names]
    #FIX ME names of countries/origin needs to be added - database!
    origin_names0 = ["Netherlands", "Spain"]
    session[:origin0_sample] = origin_names0
    origin_names1 = ["Netherlands", "Spain"]
    session[:origin1_sample] = origin_names1

    redirect_to root_path
  end

  def name_search
    search_term = params[:searched_name]
    @found_name = Name.where(name: search_term)
    @origins = Origin.find_by_sql("SELECT o.origin FROM
      names_origins m
      JOIN origins o ON m.origin_id = o.id
      JOIN names n ON m.name_id = n.id
      WHERE n.name = '#{@found_name}'")

    # @origins = []
    # unless @found_name.empty?
    #   @found_name.each do |name|
    #    origin = Origin.where(origins.name_id: name.id)
    #    @origins << origin
     #end
   #end
  end

end
