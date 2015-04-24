


class View extends Gotham.Graphics.Container

  constructor: (controller) ->
    super
    @_v = true
    @_created = false
    @_processes = []
    @Controller = controller

  # This function should be overriden, It creates the view
  #
  #
  create: ->
    throw new Error "create() must be overriden"

  # Adds a process which is executed in the game loo
  #
  #
  addProcess: (func) ->
    @_processes.push func



module.exports = View