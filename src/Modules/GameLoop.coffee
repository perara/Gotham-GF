


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
# @constructor
# @param fps {Number} The FPS limit
###
class GameLoop


  # Constructs the game loop
  # This initiates the updateLoop
  constructor: (fps) ->
    that = @

    ###*
    # The renderer instance
    # @property renderer {Gotham.Renderer}
    # @private
    ###
    @renderer = ->

    ###*
    # Tasks to execute in the game loop
    # @property _tasks {Callback[]}
    # @private
    ###
    @_tasks = []

    ###*
    # FPS Meter Instance. Shows FPS on screen
    # @property FPSMeter {FPSMeter}
    # @private
    ###
    @FPSMeter = new FPSMeter( { decimals: 0, graph: true, theme: 'dark', left: "47%", top: "96%" });

    ###*
    # Stats the animation loop
    # @method animate
    # @private
    ###
    animate = (time) ->
      requestAnimationFrame( animate );
      that.update(time)

    requestAnimationFrame animate

  ###*
  # Sets the renderer of the game loop
  # @method setRenderer
  # @param renderer {Gotham.Renderer}
  ###
  setRenderer: (renderer) ->
    @renderer = renderer

  ###*
  # The update loop function
  # This function are started in the constructor and runs in the preset FPS
  # It updates logic and draw + Tween
  # @method update
  # @param time {Long} Duration of the application runtime
  # @private
  ###
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



  ###*
  # Function which adds a task to be completed in the render loop
  # This runs until the Task returns false, will then be deleted from queue
  # @method addTask
  # @param task {Function} The Task function
  ###
  addTask: (task)->
    @_tasks.push task



module.exports = GameLoop