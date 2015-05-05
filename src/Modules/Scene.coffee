


###*
# Scene inherits {http://www.goodboydigital.com/pixijs/docs/classes/Stage.html PIXI.Stage}
#
# Stages are now Scenes which is now in a {http://en.wikipedia.org/wiki/Scene_graph Scene Graph} Structure
#
# See {http://www.goodboydigital.com/pixijs/docs/classes/Stage.html PIXI.Stage} for properties
# @class Scene
# @module Framework
# @submodule Framework
# @namespace Gotham
# @constructor
# @extends PIXI.Container
###
class Scene extends PIXI.Container

  # Runs the create() function and calls the super constructor
  constructor: ->
    super
    @__children = {}
    @create()


  # Function which should be overrided by the Scene
  create: ->
    #throw new Error "create() must be overriden by a scene!"

  # Gets a child by name
  #
  # @param name {String} Child name
  # @return {DisplayObject} The child
  getObject: (name) ->
    return @__children[name]

  # Adds a child to the Stage
  #
  # @param child {DisplayObject} The display object to remove
  # @return {DisplayObject} The display object removed, undefined if none
  addObject: (child)->

    @addChild child.View

    child.scene = @
    child.View.scene = @
    if not child.View._created then child.View.create()
    if not child._created then child.create()
    child.View._created = true
    child._created = true


    if not child.name then throw Error "Missing @name property!"

    @__children[child.name] = child

    return child


  # Removes a child
  #
  # @param child {DisplayObject} The display object to remove
  # @return {DisplayObject} The display object removed, undefined if none
  removeObject: (child) ->
    delete @__children[child.name]

    child.scene = null
    child.View.scene = null
    child._created = false
    child.View._created = false


    return @removeChild child.View








module.exports = Scene