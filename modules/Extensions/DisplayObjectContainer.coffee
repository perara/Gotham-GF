
PIXI.DisplayObjectContainer.prototype.onWheelScroll = null

PIXI.DisplayObjectContainer.prototype.network = null
PIXI.DisplayObjectContainer.prototype.addNetworkMethod = (methodName , method) ->
  console.log @network
  @network.client[methodName] = method
PIXI.DisplayObjectContainer.prototype.setNetworkHub = (hubName) ->
  @network = GothamGame.network.connection[hubName]



PIXI.DisplayObjectContainer.prototype.activatePan = () ->
  that = @
  parent = that.parent

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

    that._dx += dx
    that._dy += dy

    that.position.x += dx
    that.position.y += dy
    prevX = pos.x
    prevY = pos.y


