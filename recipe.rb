class Recipe
  attr_reader :name, :cooking_time, :description, :difficulty

  def initialize(name, cooking_time, difficulty, description)
    @name = name
    @cooking_time = cooking_time
    @difficulty = difficulty
    @description = description
    @tested = false
  end

  def tested!
    @tested = true
  end

  def tested?
    @tested
  end
end
