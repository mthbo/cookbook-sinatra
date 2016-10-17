require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "cookbook.rb"
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end
set :bind, '0.0.0.0'

csv_file   = File.join(__dir__, 'recipes.csv')
cookbook   = Cookbook.new(csv_file)

get '/' do
  erb :index
end

get '/recipes' do
  @recipes = cookbook.all
  erb :recipes
end

get '/recipes/new' do
  erb :new_recipe
end

get '/recipes/destroy' do
  @recipes = cookbook.all
  erb :delete_recipe
end

post '/recipes' do
  new_recipe = params[:new_recipe]
  create_recipe = Recipe.new(new_recipe[:name], new_recipe[:cooking_time], new_recipe[:difficulty], new_recipe[:description])
  cookbook.add_recipe(create_recipe)
  erb :index
end

delete '/recipes' do
  recipe_to_destroy = params[:recipe_to_destroy]
  index = recipe_to_destroy[:index].to_i - 1
  cookbook.remove_recipe(index)
end


# get '/team/:username' do
#   puts params[:username]
#   "The username is #{params[:username]}"
# end
