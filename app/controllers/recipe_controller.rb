class RecipeController < ApplicationController
  def index
    @recipes = (params[:keywords]) ?
                 Recipe.where('name ilike ?',"%#{params[:keywords]}%") : []
  end

  def show
    @recipe = Recipe.find(params[:id])
  end
end
