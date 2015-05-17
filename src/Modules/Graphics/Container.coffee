
###*
# Container is just a wrapper around Pixi Container
# @class Container
# @module Framework
# @submodule Framework.Graphics
# @namespace Gotham.Graphics
# @extends PIXI.Container
###
class Container extends PIXI.Container

  ###*
  # The created state of the container
  # @property {Boolean} _created
  # @private
  ###
  _created = false

  #constructor: ->
  #  super

  ###*
  # Create function, must be overriden
  # @method create
  ###
  create: ->
    throw new Exception "Override Create Method"

  ###*
  # Must be overridden
  # @method update
  ###
  update: ->
    throw new Exception "Override Update Method"

module.exports = Container