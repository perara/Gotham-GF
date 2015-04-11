


class Controller

  constructor: (View, name) ->
    # Create an instance of the View
    ViewObject = new View

    # Check that the ViewObject is an actual view
    if not ViewObject._v then throw Error "View is missing in super constructor (Have your view inherited GothamGame.View ?"

    @_created = false
    @_processes = []
    @name = name

    # Set the view property
    @View = ViewObject



  # This function should be overriden, It creates the controller
  #
  #
  create: ->
    throw new Error "create() must be overriden"

  # Adds a process which is executed in the game loo
  #
  #
  addProcess: (func) ->
    @_processes.push func


module.exports = Controller