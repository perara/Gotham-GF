mozAddWheelListener = require '../../dependencies/mozAddWheelListener'

# Adds WheelScroll support onto the pixi renderer
#
#
class ScrollWheel

  constructor: (renderer) ->
    # Add wheelListener
    @objects = []

    that = @
    mozAddWheelListener renderer.view, (e) ->
      for object in that.objects
          object.onScrollWheel(e)


  activate: (object) ->
    @objects.push(object)
    @addPanning(object)

  addPanning: (object) ->
    parent = object.parent


    object.interactive = true
    parent.interactive = true

    isDragging = false
    prevX = undefined
    prevY = undefined

    parent.mousedown = (moveData) ->
      pos = moveData.global
      prevX = pos.x
      prevY = pos.y
      isDragging = true

    parent.mouseup = (moveDate) ->
      isDragging = false


    parent.mousemove = (moveData) ->
      if !isDragging
        return
      pos = moveData.global
      dx = pos.x - prevX
      dy = pos.y - prevY

      object._dx += dx
      object._dy += dy

      object.position.x += dx
      object.position.y += dy
      prevX = pos.x
      prevY = pos.y








module.exports = ScrollWheel