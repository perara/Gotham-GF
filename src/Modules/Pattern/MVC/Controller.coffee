

###*
# Baseclass for the controller
# @class Controller
# @module Framework
# @submodule Framework.Pattern.MVC
# @namespace Gotham.Pattern.MVC
# @constructor
# @param View {Gotham.Pattern.MVC.View} The view object
# @param name {String} Name of the Controller
###
class Controller

  constructor: (View, name) ->
    # Create an instance of the View
    ViewObject = new View(@)

    # Check that the ViewObject is an actual view
    if not ViewObject._v then throw Error "View is missing in super constructor (Have your view inherited GothamGame.View ?"

    ###*
    # The created state of the controller
    # @property {Boolean} _created
    # @private
    ###
    @_created = false

    ###*
    # Processes belonging to this controller (Ran by GameLoop)
    # @property {Array} _processes
    ###
    @_processes = []

    ###*
    # Name of the controller
    # @property {String} name
    ###
    @name = name

    ###*
    # View of the controller
    # @property {Gotham.Pattern.MVC.View} View
    ###
    @View = ViewObject



  ###*
  # This function should be overriden, It creates the controller
  # @method create
  ###
  create: ->
    throw new Error "create() must be overriden"

  ###*
  # Adds a process which is executed in the game loo
  # @method addProcess
  # @param func {Function} the function to execute in the game loop
  ###
  addProcess: (func) ->
    @_processes.push func


module.exports = Controller