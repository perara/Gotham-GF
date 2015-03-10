mozAddWheelListener = require '../Dependencies/mozAddWheelListener'

PIXI.CanvasRenderer.prototype.wheelScrollObjects = []

PIXI.CanvasRenderer.prototype.addWheelScrollObject =  (object) ->
  @wheelScrollObjects.push(object)

PIXI.CanvasRenderer.prototype.setWheelScroll = (state) ->

  if not state?

    mozAddWheelListener @view, (e) ->
  else
    mozAddWheelListener @view, (e) ->
      for object in PIXI.CanvasRenderer.prototype.wheelScrollObjects
        object.onWheelScroll(e)

