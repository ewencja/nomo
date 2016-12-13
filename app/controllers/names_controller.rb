class NamesController < ApplicationController

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
      @sample_soundex = Name.find_by_sql("SELECT b.name, b.metaphone
        FROM names a
        JOIN NAMES b
        ON left(a.name, 1) = left(b.name, 1) and right(a.name, 1) = right(b.name, 1) and length(a.metaphone) = length(b.metaphone)
        WHERE a.name = '#{@name.name}'")
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
