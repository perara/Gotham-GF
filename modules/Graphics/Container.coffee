

class Container extends PIXI.DisplayObjectContainer

  _created = false
  constructor: ->
    super

  create: ->
    throw new Exception "Override Create Method"

  update: ->
    throw new Exception "Override Update Method"




module.exports = Container