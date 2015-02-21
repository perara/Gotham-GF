
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
    rootScene = new Gotham.Graphics.Scene(0x97c56e, true)

    # Add Text Label instructing to change stage
    rootScene.addChild new Gotham.Graphics.Text("Gotham Game Engine", {font: "35px Arial", fill: "white", align: "left"}, 220, 255)
    
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
  # @return [void] None
  setScene: (name) ->
    scene = @scenes[name]


    @pixi.stage = scene

  addScene: (name, scene) ->
    scene._renderer = @
    @scenes[name] = scene










module.exports = Renderer