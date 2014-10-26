describe "RecipeController", ->
  scope       = null
  ctrl        = null
  routeParams = null
  httpBackend = null
  flash       = null
  recipeId    = 42

  fakeRecipe =
    id: recipeId
    name: "Baked Potatoes"
    instructions: "Just fry it faggot!"

  setupController = (recipeExists=true) ->
    inject(($location, $routeParams, $rootScope, $resource, $httpBackend, $controller , _flash_) ->
      scope       = $rootScope.$new()
      routeParams = $routeParams
      httpBackend = $httpBackend
      flash = _flash_
      routeParams.recipeId = recipeId

      request = new RegExp("recipe/#{recipeId}")
      results = if recipeExists then [200, fakeRecipe] else [404]

      httpBackend.expectGET(request).respond(results[0], results[1])
      ctrl = $controller('RecipeController', $scope: scope)
    )

  beforeEach(module('receta'))

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  describe 'Controller initialization', ->
    describe 'recipe is found', ->
      beforeEach(setupController(true))
      it 'loads the given recipe', ->
        httpBackend.flush()
        expect(scope.recipe).toEqualData(fakeRecipe)
    describe 'recipe is not found', ->
      beforeEach(setupController(false))
      it 'loads no recipe', ->
        httpBackend.flush()
        expect(scope.recipe).toBe(null)
        expect(flash.error).toBe("There is no recipe with ID: #{recipeId}")
