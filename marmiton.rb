require 'nokogiri'
require 'open-uri'
# require 'pry-byebug'

class Marmiton
  def initialize
    @recipes_scraped = []
  end

  def search(ingredient, difficulty)
    url = "http://www.marmiton.org/recettes/recherche.aspx?aqt=#{ingredient}"
    html_file = open(url)
    html_doc = Nokogiri::HTML(html_file, nil, 'utf-8')
    html_doc.search('.m_contenu_resultat').each do |element|
      name_mark = element.xpath("div[@class='m_titre_resultat']/a")
      next if name_mark.to_a == []
      name = name_mark.attribute("title").to_s
      description = element.xpath("div[@class='m_texte_resultat']").text
      cooking_time = element.xpath("div[@class='m_detail_time']/div").text.strip
      difficulty_found = element.xpath("div[@class='m_detail_recette']").text.split("-")[2].strip
      unless difficulty == ""
        next unless difficulty_found.downcase == difficulty.downcase
      end
      @recipes_scraped << { name: name, cooking_time: cooking_time , difficulty: difficulty_found, description: description }
    end
    @recipes_scraped
  end

end
