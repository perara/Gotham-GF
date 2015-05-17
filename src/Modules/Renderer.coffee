


###*
# Renderer of the Gotham Game framework
# Uses pixi's renderer which is then wrapped around
# This is mostly an internal class for Gotham
# @class Renderer
# @module Framework
# @submodule Framework
# @namespace Gotham
# @constructor
# @param width {Integer} Width of the rendered area
# @param height {Integer} Height of the rendered area
# @param options {Object} Additional Option Parameters
# @param autoResize {Boolean} Weither the renderer should automaticly resize to window size
###
class Renderer


  constructor: (width, height, options, autoResize) ->
    # Create pixi object
    that =  @

    ###*
    # The pixi renderer instance
    # @property {PIXI.Renderer} pixi
    ###
    @pixi = PIXI.autoDetectRenderer width, height, {
      autoResize: true
      antialias: true
    }

    window.renderer = @

    # Activate Wheel Scrolling Support (Defined in Extensions)
    @pixi.setWheelScroll(true)

    window.addEventListener 'contextmenu',(e) ->
      e.preventDefault()

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

    ###*
    # All scene objects, By default "root" is defined
    # @property {Object} scenes
    # @private
    ###
    @scenes =
      "root": @pixi.stage

    # Append renderer to the document
    document.body.appendChild @pixi.view

    window.onfocus = ->
      Gotham.Running = true

    window.onblur = ->
      Gotham.Running = false


    # Add a render loop function to the Gotham.GameLoop
    Gotham.GameLoop.setRenderer () ->
      renderer.pixi.render(renderer.pixi.stage);

  ###*
  # Sets current stage to defined name, errors out if not exists
  # @method setScene
  # @param name {String} The scene name
  ###
  setScene: (name) ->
    scene = @scenes[name]
    @pixi.stage = scene

  ###*
  # Adds a new scene to the renderer
  # @method addScene
  # @param name {String} Name of the Scene
  # @param scene {Gotham.Scene} The Scene object
  ###
  addScene: (name, scene) ->
    scene._renderer = @
    @scenes[name] = scene

  ###*
  # Retrieves a scene from the renderer
  # @method getScene
  # @param name {String} Name of the scene
  # @returns {Gotham.Scene} The scene object with the given name
  ###
  getScene: (name) ->
    return @scenes[name]


module.exports = Renderer