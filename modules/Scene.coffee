

# Scene inherits {http://www.goodboydigital.com/pixijs/docs/classes/Stage.html PIXI.Stage}
#
# Stages are now Scenes which is now in a {http://en.wikipedia.org/wiki/Scene_graph Scene Graph} Structure
#
# See {http://www.goodboydigital.com/pixijs/docs/classes/Stage.html PIXI.Stage} for properties
#
class Scene extends PIXI.Stage

  # Runs the create() function and calls the super constructor
  constructor: ->
    super
    @create()

  childrenMap = {}

  # Function which should be overrided by the Scene
  create: ->
    #throw new Error "create() must be overriden by a scene!"

  # Fetches a object from the children map
  # @param [String] name Fetches object with the given name
  # @return [Object] Child object (Drawable)
  getObject: (name) ->
    return childrenMap[name]

  # Adds a object to the scene
  # @param [Drawable] object The object to be added as an child
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


  # Removes a object from the child map/array
  # @param [Object] object Object which to be removed
  removeObject: (object) ->
    delete childrenMap[object.name]
    @removeChild object



module.exports = Scene