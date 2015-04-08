mozAddWheelListener = require '../Dependencies/mozAddWheelListener'

# @property [Array] List of all objects that have activated wheelScrolling
PIXI.WebGLRenderer.prototype.wheelScrollObjects = []


# Adds a function to add wheel scrolling to an object
PIXI.WebGLRenderer.prototype.addWheelScrollObject =  (object) ->
  @wheelScrollObjects.push(object)


# Toggles on or off wheelScrolling in PIXI.WebGLRenderer
# This adds the prototype to PIXI.WebGLRenderer
# @param [Boolean]state True or False
PIXI.WebGLRenderer.prototype.setWheelScroll = (state) ->

  if not state?
    mozAddWheelListener @view, (e) ->
  else
    mozAddWheelListener @view, (e) ->
      for object in PIXI.WebGLRenderer.prototype.wheelScrollObjects
        object.onWheelScroll(e)

##
##
# Canvas
##
##


# @property [Array] List of all objects that have activated wheelScrolling
PIXI.CanvasRenderer.prototype.wheelScrollObjects = []

# Adds a function to add wheel scrolling to an object
PIXI.CanvasRenderer.prototype.addWheelScrollObject =  (object) ->
  @wheelScrollObjects.push(object)

# Toggles on or off wheelScrolling in PIXI.WebGLRenderer
# This adds the prototype to PIXI.WebGLRenderer
# @param [Boolean]state True or False
PIXI.CanvasRenderer.prototype.setWheelScroll = (state) ->

  if not state?

    mozAddWheelListener @view, (e) ->
  else
    mozAddWheelListener @view, (e) ->
      for object in PIXI.CanvasRenderer.prototype.wheelScrollObjects
        object.onWheelScroll(e)

