
###*
# Container is just a wrapper around Pixi Container
# @class Container
# @module Framework
# @submodule Framework.Graphics
# @namespace Gotham.Graphics
# @extends PIXI.Container
###
class Container extends PIXI.Container

  _created = false

  #constructor: ->
  #  super

  # Must be overridden
  create: ->
    throw new Exception "Override Create Method"

  # Must be overridden
  update: ->
    throw new Exception "Override Update Method"

module.exports = Container