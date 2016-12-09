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


end
