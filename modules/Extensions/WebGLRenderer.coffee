mozAddWheelListener = require '../../dependencies/mozAddWheelListener'

PIXI.WebGLRenderer.prototype.wheelScrollObjects = []

PIXI.WebGLRenderer.prototype.addWheelScrollObject =  (object) ->
  @wheelScrollObjects.push(object)

PIXI.WebGLRenderer.prototype.setWheelScroll = (state) ->

  if not state?

    mozAddWheelListener @view, (e) ->
  else
    mozAddWheelListener @view, (e) ->
      for object in PIXI.WebGLRenderer.prototype.wheelScrollObjects
        object.onWheelScroll(e)

