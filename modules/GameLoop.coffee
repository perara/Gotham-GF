

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

    # Check if fps is set, if not set the fps to 60
    if not fps then @fps = 60 else @fps = fps

    # Sets how fast PIXI calls the Interaction checks
    #PIXI.INTERACTION_FREQUENCY = 60;

    # Starts the update loop
    animate = (time) ->
      requestAnimationFrame( animate );
      that.update(time)
    requestAnimationFrame animate


  # @property [Object] Contains functions for logic update and draw updates. These are added by the user
  methods =
      "logic" : []
      "draw" : []


  # The update loop function
  # This function are started in the constructor and runs in the preset FPS
  # It updates logic and draw + Tween
  #
  # @param [long] Duration of the application runtime
  # @return [void] Nothing
  #
  update: (time) ->

    # Update Logic
    for key, logic of methods["logic"]
      logic()

    # Update Drawing
    for key, draw of methods["draw"]
      draw()

    # Update Tweening
    Gotham.Tween.update(time);


  # Adds a logic function to the update loop
  # @param [function] The logic function to run in update()
  # @return [void] Nothing
  addLogic: (method) ->
    methods["logic"].push(method)

  # Adds a draw function to the update loop
  # @param [function] The draw function to run in update()
  # @return [void] Nothing
  addDraw: (method) ->
    methods["draw"].push(method)




module.exports = GameLoop