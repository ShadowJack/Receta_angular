describe "RecipesController", ->
  scope       = null
  ctrl        = null
  location    = null
  routeParams = null
  resource    = null
  httpBackend = null

  setupController = (keywords, results) ->
    inject(($location, $routeParams, $rootScope, $resource, $httpBackend, $controller ) ->
      scope       = $rootScope.$new()
      location    = $location
      resource    = $resource
      routeParams = $routeParams
      httpBackend = $httpBackend
      routeParams.keywords = keywords

      if results
        request = new RegExp("\/recipe.*keywords=#{keywords}")
        httpBackend.expectGET(request).respond(results)

      ctrl = $controller('RecipesController', $scope: scope, $location: location)
    )

  beforeEach(module('receta'))
  beforeEach(setupController())

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  describe 'controller initilization', ->
    describe 'when no keywords present', ->
      beforeEach(setupController())

      it 'defaults to no recipes', ->
        expect(scope.recipes).toEqualData([])

    describe 'with keywords', ->
      keywords = 'foo'
      recipes = [
        {
          id: 2
          name: 'Baked Potatoes'
        },
        {
          id: 4
          name: 'Potatoes Au Gratin'
        }
      ]
      beforeEach ->
        setupController(keywords,recipes)
        httpBackend.flush()

      it 'calls the back-end', ->
        expect(scope.recipes).toEqualData(recipes)

    describe 'search()', ->
      beforeEach ->
        setupController()

      it 'redirects to itself with a keyword param', ->
        keywords = 'foo'
        scope.search(keywords)
        expect(location.path()).toBe('/')
        expect(location.search()).toEqualData({keywords: keywords})