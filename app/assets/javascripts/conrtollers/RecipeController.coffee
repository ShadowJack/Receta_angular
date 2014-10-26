controllers = angular.module('controllers')

controllers.controller('RecipeController', ['$scope', '$location', '$routeParams', '$resource', 'flash', ($scope, $location, $routeParams, $resource, flash) ->
  Recipe = $resource('/recipe/:recipeId', {recipeId: "@id", format: 'json'})
  Recipe.get({recipeId: $routeParams.recipeId},
    ((recipe) -> $scope.recipe = recipe),
    ((httpResponse) ->
      $scope.recipe = null
      flash.error = "There is no recipe with ID: #{$routeParams.recipeId}"
    )
  )

  $scope.back = -> $location.path('/')
])