


###*
# GameLoop of the engine
#
# This is responsible for updating and drawing each frame of
# the game, It does so by calling requestAnimationFrame.
#
# In Addition, it also handles the Tween ticks in its update loop
#
# @class GameLoop
# @module Framework
# @submodule Framework
# @namespace Gotham
###
class GameLoop


  # Constructs the game loop
  # This initiates the updateLoop
  # @param [Integer] The fps upper limit
  constructor: (fps) ->
    that = @


    @renderer = ->

    @_tasks = []

    @FPSMeter = new FPSMeter( { decimals: 0, graph: true, theme: 'dark', left: "47%", top: "96%" });

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
    @FPSMeter.tickStart();


    # Run Tasks , Delete if done
    for _task in @_tasks
      s = _task()
      if not s then @_tasks.remove _task

    # Update Tweening
    Gotham.Tween.update(time)



    @renderer()



    @FPSMeter.tick();




  # Function which adds a task to be completed in the render loop
  # This runs until the Task returns false, will then be deleted from queue
  #
  # @param task {Function} The Task function
  addTask: (task)->
    @_tasks.push task



module.exports = GameLoop