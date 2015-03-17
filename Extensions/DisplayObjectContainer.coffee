
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

# onInteractiveChange fires whenever setInteractive is fired
PIXI.DisplayObjectContainer.prototype.onInteractiveChange = null

# Function which sets the interactivity
# It also fires onInteractiveChange
# This should be used when using GOTHAM instead of object.interactive = X
PIXI.DisplayObjectContainer.prototype.setInteractive = (state) ->

  # Fires Event
  if @onInteractiveChange
    @onInteractiveChange(state)

  # Create a queue for interactive items
  queue = []

  # Push the parent
  queue.push(@)

  # While we have items left in the queue
  while queue.length > 0
    # Get first item
    item = queue.pop()

    # Push all children in this object
    queue.push.apply queue, item.children

    # Set the interactive state
    item.interactive = state

    # PIXI.js FIX - https://github.com/GoodBoyDigital/pixi.js/issues/1523 //TODO
    if !state
      item.__click = item.click
      item.__mousedown = item.mousedown
      item.__mouseup = item.mouseup
      item.click = null
      item.mousedown = null
      item.mouseup = null
    else
      item.click = item.__click
      item.mousedown = item.__mousedown
      item.mouseup = item.__mouseup
      item.__click = null
      item.__mousedown = null
      item.__mouseup = null




PIXI.DisplayObjectContainer.prototype.addChildArray = (array) ->
  for child in array
    @addChild child






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



