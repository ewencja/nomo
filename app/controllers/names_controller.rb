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
end
