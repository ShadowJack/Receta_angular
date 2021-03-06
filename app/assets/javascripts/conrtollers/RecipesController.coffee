controllers = angular.module('controllers')
controllers.controller('RecipesController', ['$scope', '$routeParams', '$location', '$resource', ($scope, $routeParams, $location, $resource) ->
  $scope.search = (keywords) -> $location.path('/').search('keywords', keywords)
  Recipe = $resource('/recipe/:recipeId', {recipeId: "@id", format: 'json'})

  if $routeParams.keywords
    Recipe.query(keywords: $routeParams.keywords, (results) -> $scope.recipes = results)
  else
    $scope.recipes = []

  $scope.view = (recipeId) -> $location.path("/recipe/#{recipeId}")

  $scope.newRecipe = -> $location.path('/recipe/new')
  $scope.edit      = (recipeId) -> $location.path("/recipe/#{recipeId}/edit")

])