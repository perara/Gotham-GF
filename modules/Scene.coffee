﻿

# Scene inherits {http://www.goodboydigital.com/pixijs/docs/classes/Stage.html PIXI.Stage}
#
# Stages are now Scenes which is now in a {http://en.wikipedia.org/wiki/Scene_graph Scene Graph} Structure
#
# See {http://www.goodboydigital.com/pixijs/docs/classes/Stage.html PIXI.Stage} for properties
#
class Scene extends PIXI.Stage

  Container = null

  # @param backgroundColor [Hex] Color in Hex format
  constructor: ->
    super
    @create()

  childrenMap = {}

  create: ->
    #throw new Error "create() must be overriden by a scene!"

  getObject: (name) ->
    return childrenMap[name]

  addObject: (object) ->
    # Add to the Container children Map
    if not object.name?
      throw new Error "object.name is " +  object.name + ", Please define!"

    # Add to the PIXI.DisplayObjectContainer
    @addChild object
    childrenMap[object.name] = object

    # Run Create Function if not already done
    if not object._created?
      object.create()
      object._created = true


  removeObject: (object) ->
    delete childrenMap[object.name]
    @removeChild object









module.exports = Scene