describe "RecipeController", ->
  scope       = null
  location    = null
  ctrl        = null
  routeParams = null
  httpBackend = null
  flash       = null
  recipeId    = 42

  fakeRecipe =
    id: recipeId
    name: "Baked Potatoes"
    instructions: "Just fry it faggot!"

  setupController = (recipeExists=true, recipeId=42) ->
    inject(($location, $routeParams, $rootScope, $resource, $httpBackend, $controller , _flash_) ->
      scope       = $rootScope.$new()
      location    = $location
      routeParams = $routeParams
      httpBackend = $httpBackend
      flash = _flash_
      routeParams.recipeId = recipeId if recipeId

      if recipeId
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

  describe 'create', ->
    newRecipe =
      id: 42
      name: 'Toast'
      instructions: 'put in toaster, push lever, add butter'

    beforeEach ->
      setupController(false,false)
      request = new RegExp("\/recipe")
      httpBackend.expectPOST(request).respond(201,newRecipe)

    it 'posts to the backend', ->
      scope.recipe.name         = newRecipe.name
      scope.recipe.instructions = newRecipe.instructions
      scope.save()
      httpBackend.flush()
      expect(location.path()).toBe("/recipe/#{newRecipe.id}")

  describe 'update', ->
    updatedRecipe =
      name: 'Toast'
      instructions: 'put in toaster, push lever, add butter'

    beforeEach ->
      setupController()
      httpBackend.flush()
      request = new RegExp("\/recipe")
      httpBackend.expectPUT(request).respond(204)

    it 'posts to the backend', ->
      scope.recipe.name         = updatedRecipe.name
      scope.recipe.instructions = updatedRecipe.instructions
      scope.save()
      httpBackend.flush()
      expect(location.path()).toBe("/recipe/#{scope.recipe.id}")

  describe 'delete' ,->
    beforeEach ->
      setupController()
      httpBackend.flush()
      request = new RegExp("\/recipe/#{scope.recipe.id}")
      httpBackend.expectDELETE(request).respond(204)

    it 'posts to the backend', ->
      scope.delete()
      httpBackend.flush()
      expect(location.path()).toBe("/")
