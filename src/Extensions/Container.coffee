
# @property [Callback] callback for when wheel scrolling is done
PIXI.Container.prototype.onWheelScroll = ->

# Function which brings an item in the children array to front
PIXI.Container.prototype.bringToFront = ->
  if this.parent
    #console.log "Front!"
    parent = this.parent
    parent.removeChild(this)
    parent.addChild(this)

# @property [Callback] onInteractiveChange fires whenever setInteractive is fired
PIXI.Container.prototype.onInteractiveChange = null

# Function which sets the interactivity
# It also fires onInteractiveChange
# This should be used when using GOTHAM instead of object.interactive = X
# @param [Boolean] state True or False, (Enable/Disable)
PIXI.Container.prototype.setInteractive = (state) ->

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
PIXI.Container.prototype.addChildArray = (array) ->
  for child in array
    @addChild child


# Activates panning on "this" object, (Moving the object around)
# @param [Callback] callback Callback for adding an custom restriction for the panning, Example when it should stop (Borders, and limits)
PIXI.Container.prototype.setPanning = (callback) ->
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



  parent.mousedown = (e) ->

    pos = e.data.getLocalPosition @
    prevX = pos.x
    prevY = pos.y
    isDragging = true

  parent.mouseup = (e) ->
    isDragging = false

  parent.mouseout = (e) ->
    isDragging = false

  parent.mousemove = (e) ->
    if !isDragging
      return

    # Current mouse position
    pos = e.data.getLocalPosition @

    # The difference between previous and current poss
    that.diff.x = pos.x - prevX
    that.diff.y = pos.y - prevY

    newPosition =
      x: that.position.x + that.diff.x
      y: that.position.y + that.diff.y

    results = callback(newPosition)

    if results.x
      that.position.x = newPosition.x
      prevX = pos.x
    if results.y
      that.position.y = newPosition.y
      prevY = pos.y

PIXI.Container.prototype.onMouseDown = ->
PIXI.Container.prototype.onMouseUp = ->
PIXI.Container.prototype.onMove = ->
PIXI.Container.prototype.movable = ->

  if not @interactive
    @interactive = true

  @mousedown = @touchstart = (e) ->
    @dragging = true
    @_sx = e.data.getLocalPosition(@).x * @scale.x;
    @_sy = e.data.getLocalPosition(@).y * @scale.y;
    @onMouseDown(e)

  @mouseup = @mouseupoutside = @touchend =@touchendoutside = (data) ->
    @alpha = 1
    @dragging = false
    @data = null
    @onMouseUp(data)

  @mousemove = @touchmove = (e) ->
    if @dragging
      newPosition = e.data.getLocalPosition(this.parent);
      @position.x = newPosition.x - @_sx;
      @position.y = newPosition.y - @_sy;
      @onMove(e)


