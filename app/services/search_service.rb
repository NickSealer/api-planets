class SearchService

  def self.search_form(forms, query)
    forms.where("name LIKE '%#{query}%'")
  end

  def self.search_galaxy(galaxies, query)
    galaxies.where("name LIKE '%#{query}%'")
  end

  def self.search_planet(planets, query)
    planets.where("name LIKE '%#{query}%'")
  end

end
