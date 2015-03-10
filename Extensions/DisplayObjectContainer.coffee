
PIXI.DisplayObjectContainer.prototype.onWheelScroll = null

PIXI.DisplayObjectContainer.prototype.network = null
PIXI.DisplayObjectContainer.prototype.addNetworkMethod = (methodName , method) ->
  @network.client[methodName] = method


PIXI.DisplayObjectContainer.prototype.setNetworkHub = (hubName) ->
  @network = GothamGame.network.connection[hubName]

PIXI.DisplayObjectContainer.prototype.bringToFront = ->
  if this.parent
    console.log "Front!"
    parent = this.parent
    parent.removeChild(this)
    parent.addChild(this)

PIXI.DisplayObjectContainer.prototype.activatePan = (mouseMoveRestriction) ->
  that = @
  parent = that.parent

  parent.interactive = true

  isDragging = false
  prevX = undefined
  prevY = undefined

  that.offset =
    x: 0
    y: 0

  that.diff =
    x: 0
    y: 0



  parent.mousedown = (moveData) ->
    pos = moveData.global
    prevX = pos.x
    prevY = pos.y
    isDragging = true

  parent.mouseup = (moveDate) ->
    isDragging = false

  parent.mouseout = (moveData) ->
    isDragging = false

  #parent.mouseover = (mouseData) ->



  parent.mousemove = (moveData) ->
    if !isDragging
      return
    pos = moveData.global
    that.diff.x = pos.x - prevX
    that.diff.y = pos.y - prevY

    that.offset.x += that.diff.x
    that.offset.y += that.diff.y

    that.position.x += that.diff.x
    that.position.y += that.diff.y
    prevX = pos.x
    prevY = pos.y

    mouseMoveRestriction(that.position.x, that.position.y)



