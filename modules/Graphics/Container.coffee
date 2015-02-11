

class Container extends PIXI.DisplayObjectContainer

  constructor: ->
    super

    console.log "woooW"


  childrenMap = {}
  addChildName: (name, object) ->
    @addChild object
    @childrenMap[name] = object



  create: ->
    throw new Exception "Override Create Method"

  update: ->
    throw new Exception "Override Update Method"




module.exports = Container