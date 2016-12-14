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
    # Variant with no origins selected for soundex
      @sample_soundex = Name.find_by_sql("SELECT b.name
        FROM names a
        JOIN NAMES b
        ON left(a.name, 1) = left(b.name, 1) and right(a.name, 1) = right(b.name, 1) and length(a.metaphone) = length(b.metaphone) and a.gender = b.gender
        WHERE a.name = '#{@name.name}'")
    # Variant with origins selected for soundex
      # @sample_soundex_origins = Name.find_by_sql("SELECT b.name, o.origin, b.gender
      #   FROM names
      #   JOIN names_origins
  	  #   ON names_origins.name_id = names.id
      #   JOIN origins
  	  #   ON names_origins.origin_id = origins.id
      #   JOIN names b
  	  #   ON left(names.name, 1) = left(b.name, 1) and right(names.name, 1) = right(b.name, 1) and length(names.metaphone) = length(b.metaphone) and names.gender = b.gender
      #   WHERE (origins.origin = 'German' or origins.origin = 'Polish') and names.gender = 'feminine' and (names.name = '#{@name.name}'")
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
