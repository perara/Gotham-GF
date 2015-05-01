

# GameLoop of the engine
#
# This is responsible for updating and drawing each frame of
# the game, It does so by calling requestAnimationFrame.
#
# In Addition, it also handles the Tween ticks in its update loop
class GameLoop



  # Constructs the game loop
  # This initiates the updateLoop
  # @param [Integer] The fps upper limit
  constructor: (fps) ->
    that = @

    @renderer = ->

    @_tasks = []

    # Check if fps is set, if not set the fps to 60
    if not fps then @fps = 200 else @fps = fps

    # Sets how fast PIXI calls the Interaction checks
    PIXI.INTERACTION_FREQUENCY = 60

    # Starts the update loop
    animate = (time) ->
      requestAnimationFrame( animate );
      that.update(time)
    requestAnimationFrame animate

  setRenderer: (renderer) ->
    @renderer = renderer


  # The update loop function
  # This function are started in the constructor and runs in the preset FPS
  # It updates logic and draw + Tween
  #
  # @param [long] Duration of the application runtime
  # @return [void] Nothing
  #
  update: (time) ->
    @renderer()

    # Run Tasks , Delete if done
    for _task in @_tasks
      s = _task()
      if not s then @_tasks.remove _task

    # Update Tweening
    Gotham.Tween.update(time)




  # Function which adds a task to be completed in the render loop
  # This runs until the Task returns false, will then be deleted from queue
  #
  # @param task {Function} The Task function
  addTask: (task)->
    @_tasks.push task








module.exports = GameLoop