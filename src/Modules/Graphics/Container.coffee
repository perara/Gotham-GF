
# Container class which inherits PIXI.DisplayObjectContainer
#
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