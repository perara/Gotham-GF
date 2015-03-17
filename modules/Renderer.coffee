

# Renderer of the Gotham Game framework
# Uses pixi's renderer which is then wrapped around
# This is mostly an internal class for Gotham
class Renderer

  
  # Constructs a PIXI renderer and appends it to the body of the document DOM
  # 
  # @param Width [Integer] Width of the rendered area
  # @param Height [Integer] Height of the rendered area
  # @param Options [Object] Additional Option Parameters
  # @param autoResize [Boolean] Weither the renderer should automaticly resize to window size
  # @example Creating a renderer object
  #   # Create the renderer object
  #   renderer = new Gotham.Graphics.Renderer(800,600, {})
  #
  constructor: (width, height, options, autoResize) ->
    # Create pixi object
    that =  @
    @pixi = PIXI.autoDetectRenderer width, height, options
    window.renderer = @

    # Activate Wheel Scrolling Support (Defined in Extensions)
    @pixi.setWheelScroll(true)


    # Add Resize handler if set to true
    if autoResize?
      @pixi.view.style.width = window.innerWidth + 'px'
      @pixi.view.style.height = window.innerHeight + 'px'
      window.addEventListener "resize", () ->
        that.pixi.view.style.width = window.innerWidth + 'px'
        that.pixi.view.style.height = window.innerHeight + 'px'


    # Create initial pixi stage (Root)
    rootScene = new Gotham.Graphics.Scene(0x000000, true)

    # Add Text Label instructing to change stage
    label = new Gotham.Graphics.Text("Gotham Game Engine", {font: "35px Arial", fill: "white", align: "left"}, 1920/2, 1080/2)
    label.anchor =
      x: 0.5
      y: 0.5
    rootScene.addChild label
    
    # Sets current stage and maps it as Root in object
    @pixi.stage = rootScene
    @scenes =
      "root": @pixi.stage

    # Append renderer to the document
    document.body.appendChild @pixi.view

    # Add a render loop function to the Gotham.GameLoop
    Gotham.GameLoop.addDraw () ->
      renderer.pixi.render(renderer.pixi.stage)

  # Sets current stage to defined name, errors out if not exists
  # @param [String] name Name of the Scene
  # @return [void] None
  setScene: (name) ->
    scene = @scenes[name]
    @pixi.stage = scene

  # Adds a new scene to the renderer
  # @param [String] name Name of the Scene
  # @param [Scene] scene The Scene object
  addScene: (name, scene) ->
    scene._renderer = @
    @scenes[name] = scene










module.exports = Renderer