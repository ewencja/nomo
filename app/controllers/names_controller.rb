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
    end
  end

  def names_search
    gender = params[:gender]
    origin1 = params[:origin1]
    origin2 = params[:origin2]
    occurrence = params[:occurrence]
    length = params[:length]

    if params[:join] == "or"
      names = Name.find_by_sql [
        "SELECT names.*, origins.*
        FROM names
        JOIN names_origins
        	ON names_origins.name_id = names.id
        JOIN origins
        	ON names_origins.origin_id = origins.id
        WHERE (origins.origin = ? or origins.origin = ?) and names.gender = ?
          and names.occurence = ? and names.length = ? LIMIT 15",
        origin1, origin2, gender, occurrence, length]
    else
      names = Name.find_by_sql [
        "SELECT distinct names.name, names.* FROM names

        JOIN names_origins
        	ON names_origins.name_id = names.id
        JOIN origins
        	ON names_origins.origin_id = origins.id

        WHERE name in (
  	        SELECT name FROM (SELECT names.name, COUNT(origins.origin) count
      		  FROM names
      		  JOIN names_origins
      			   ON names_origins.name_id = names.id
      		  JOIN (
              SELECT * FROM origins WHERE origins.origin = ? or origins.origin = ?) origins
        			   ON names_origins.origin_id = origins.id
        		  WHERE names.gender = ? and names.occurence = ? and names.length = ?
        		  GROUP BY names.name) names
            WHERE count = 2) LIMIT 15",
        origin1, origin2, gender, occurrence, length]
    end

    render json: names
  end

  def names
  end

end
