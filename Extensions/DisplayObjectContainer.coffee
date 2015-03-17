
# @property [Callback] callback for when wheel scrolling is done
PIXI.DisplayObjectContainer.prototype.onWheelScroll = null

# @property [Network] The network object
PIXI.DisplayObjectContainer.prototype.network = null

# Function to add an clientside network method/function
# @param [String] methodName Name of the method
# @param [Function] method The function itself
PIXI.DisplayObjectContainer.prototype.addNetworkMethod = (methodName , method) ->
  @network.client[methodName] = method

# SignalR networkHub.
# This adds the possibility to hook a network hub onto an DisplayObject (IE Sprite)
# Useful when creating objects in an game
# @param [String] hubName Name of the Network Hub
PIXI.DisplayObjectContainer.prototype.setNetworkHub = (hubName) ->
  @network = GothamGame.network.connection[hubName]

# Function which brings an item in the children array to front
PIXI.DisplayObjectContainer.prototype.bringToFront = ->
  if this.parent
    #console.log "Front!"
    parent = this.parent
    parent.removeChild(this)
    parent.addChild(this)

# @property [Callback] onInteractiveChange fires whenever setInteractive is fired
PIXI.DisplayObjectContainer.prototype.onInteractiveChange = null

# Function which sets the interactivity
# It also fires onInteractiveChange
# This should be used when using GOTHAM instead of object.interactive = X
# @param [Boolean] state True or False, (Enable/Disable)
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



# Adds an entire Array as an child to "this" object
# @param [Array] array List of children
PIXI.DisplayObjectContainer.prototype.addChildArray = (array) ->
  for child in array
    @addChild child


# Activates panning on "this" object, (Moving the object around)
# @param [Callback] mouseMoveRestriction Callback for adding an custom restriction for the panning, Example when it should stop (Borders, and limits)
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



