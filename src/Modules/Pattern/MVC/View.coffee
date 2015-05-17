

###*
# Baseclass for the View
# @class View
# @module Framework
# @submodule Framework.Pattern.MVC
# @namespace Gotham.Pattern.MVC
# @constructor
# @param controller {Gotham.Pattern.MVC.Controller} The Controller Object
# @extends Gotham.Graphics.Container
###
class View extends Gotham.Graphics.Container

  constructor: (controller) ->
    super

    ###*
    # This is a identifier that tells internal stuff that its a view.
    # @property {Boolean} _v
    # @private
    ###
    @_v = true

    ###*
    # A boolean which determine create state of the view
    # @property {Boolean} _created
    # @private
    ###
    @_created = false

    ###*
    # Processed which is executed by this view (in the game loop)
    # @property {Array} _processes
    ###
    @_processes = []

    ###*
    # The controller belonging to this view
    # @property {Gotham.Pattern.MVC.Controller}
    ###
    @Controller = controller

  ###*
  # This function should be overriden, It creates the view
  # @method create
  ###
  create: ->
    throw new Error "create() must be overriden"

  ###*
  # Adds a process which is executed in the game loop
  # @method addProcess
  # @param func {Function} Function to execute in the game loop
  ###
  addProcess: (func) ->
    @_processes.push func



module.exports = View