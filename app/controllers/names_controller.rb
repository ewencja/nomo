class NamesController < ApplicationController
  def names
    @gender = params[:gender]
  end
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

    #FIXME names of countries/origin needs to be added - database!
    origin_names = []
    origins = Origin.all
    origins.each do |origin|
      origin_names << origin.origin
    end
    session[:origin_sample] = origin_names
    redirect_to root_path
  end


  def name

    ## Method to search name navbar and return big list
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

    names = Name
      .select('names.*, origins.*')
      .joins(:origin)
      .where("names.gender = #{ActiveRecord::Base.sanitize(params[:gender])}
        and LOWER(names.name) LIKE '%#{params[:name].downcase}%'
        and (origins.origin = #{ActiveRecord::Base.sanitize(params[:origin])} or
          #{ActiveRecord::Base.sanitize(params[:origin])} = '')")
      .distinct

    render json: names
  end


  def names_suggestions
    @origin_parent = params[:origin_parent]
    @origin_baby = params[:origin_baby]
    @length = params[:length]
    @gender = params[:gender]
    #@names = Name
    #  .select('names.*, origins.*')
    #  .joins(:origin)
    #  .where("names.gender = #{ActiveRecord::Base.sanitize(params[:gender])}
    #    and (origins.origin = #{ActiveRecord::Base.sanitize(params[:origin_parent])}
    #    or (origins.origin = #{ActiveRecord::Base.sanitize(params[:origin_baby])}
    #    )")
    #  .distinct

    @names = Name.where(gender: @gender, length: "short")
  end
end
