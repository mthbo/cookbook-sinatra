require 'csv'
require_relative 'recipe.rb'

class Cookbook
  def initialize(csv_file)
    @csv_file = csv_file
    @recipes = []
    load_csv
  end

  def add_recipe(recipe)
    @recipes << recipe
    write_csv
  end

  def remove_recipe(recipe_id)
    @recipes.delete_at(recipe_id)
    write_csv
  end

  def mark_as_tested(recipe_id)
    @recipes[recipe_id].tested!
    write_csv
  end

  def all
    @recipes
  end

  private

  def write_csv
    csv_options = { col_sep: ',', quote_char: '"', force_quotes: true }
    CSV.open(@csv_file, 'w', csv_options) do |csv|
      csv << ["tested?", "name", "cooking time", "difficulty", "description"]
      @recipes.each do |recipe|
        test_mark = recipe.tested? ? "tested" : "not tested"
        csv << [test_mark, recipe.name, recipe.cooking_time, recipe.difficulty, recipe.description]
      end
    end
  end

  def load_csv
    csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
    CSV.foreach(@csv_file, csv_options) do |row|
      recipe = Recipe.new(row["name"], row["cooking time"], row["difficulty"], row["description"])
      recipe.tested! if row["tested?"] == "tested"
      @recipes << recipe
    end
  end
end
