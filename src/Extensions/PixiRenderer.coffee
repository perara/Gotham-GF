
# @property [Array] List of all objects that have activated wheelScrolling
PIXI.WebGLRenderer.prototype.wheelScrollObjects = []


# Adds a function to add wheel scrolling to an object
PIXI.WebGLRenderer.prototype.addWheelScrollObject =  (object) ->
  @wheelScrollObjects.push(object)


# Toggles on or off wheelScrolling in PIXI.WebGLRenderer
# This adds the prototype to PIXI.WebGLRenderer
# @param [Boolean]state True or False
PIXI.WebGLRenderer.prototype.setWheelScroll = (state) ->

  $(window).bind 'mousewheel DOMMouseScroll', (event)->
    if (event.originalEvent.wheelDelta > 0 || event.originalEvent.detail < 0)
      event.originalEvent.wheelDelta = 1
      event.wheelDeltaY = 1
    else
      event.originalEvent.wheelDelta = -1
      event.wheelDeltaY = -1

    if state
      for object in PIXI.WebGLRenderer.prototype.wheelScrollObjects
        object.onWheelScroll(event)

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

  $(window).bind 'mousewheel DOMMouseScroll', (event)->
    if (event.originalEvent.wheelDelta > 0 || event.originalEvent.detail < 0)
      event.originalEvent.wheelDelta = 1
      event.wheelDeltaY = 1
    else
      event.originalEvent.wheelDelta = -1
      event.wheelDeltaY = -1

    if state
      for object in PIXI.WebGLRenderer.prototype.wheelScrollObjects
        object.onWheelScroll(event)

