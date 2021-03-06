

###*
# Slider control is a control which can be dragged from 0 to 100. For example a volume control
# @class Slider
# @module Framework
# @submodule Framework.Controls
# @namespace Gotham.Controls
# @extends Gotham.Graphics.Sprite
# @constructor
# @param knobTexture {Gotham.Graphics.Texture} Texture of the knob
# @param background {Gotham.Graphics.Texture} Background texture
###
class Slider extends Gotham.Graphics.Sprite

  # Constructor Which Creates the Slider
  # The slider can then be configured as a regular sprite
  constructor: (knobTexture, background) ->
    super
    that = @

    ###*
    # onProgress callback
    # @property onProgress {Function}
    ###
    @onProgress = null

    ###*
    # Slider progress
    # @property progress {Number}
    ###
    @progress = 0

    @texture = background
    @tint = 0xFFFF00

    ###*
    # THe knob sprite
    # @property knob {Gotham.Graphics.Sprite}
    # @private
    ###
    knob = @knob = new Gotham.Graphics.Sprite knobTexture
    knob.width = @height
    knob.height = @height
    knob.setInteractive true

    # Progress text
    progress_text = new Gotham.Graphics.Text("0%",{font: "bold 20px Arial", fill: "#ffffff", align: "left"})
    progress_text.x = @width / 2
    progress_text.y = @height / 2
    progress_text.anchor =
      x: 0.5
      y: 0.5
    @addChild progress_text



    # Register dragging, Then calculate where on the Knob the user clicked (@sx)
    knob.mousedown = knob.touchstart = (e) ->
      @sx = e.data.getLocalPosition(@).x * @scale.x;
      @dragging = true

    # Deactivate dragging and reset data
    knob.mouseup = knob.mouseupoutside = knob.touchend = knob.touchendoutside = (e) ->
      @dragging = false

    # Check if user is dragging, Then move the knob accordingly
    knob.mousemove = knob.touchmove = (e) ->
      if @dragging
        newData = e.data.getLocalPosition(@parent)
        newX = (newData.x - @sx)


        #console.log newX * + " / " + @parent.width
        if newX * @parent.scale.x > @parent.width - (@width * @parent.scale.x) || newX < 0
          return
        @x = newX



        that.progress = Math.round(that.calculateProgress(@x))
        progress_text.text = that.progress + "%"
        if that.onProgress
          that.onProgress(that.progress)



    @addChild knob

  ###*
  # Calculates Current slider percentage based on knob's position
  # Accounts for scale and all that jazz
  # @method calculateProgress
  # @param x {Number} Knob's current X position
  # @return {Number} percentage in number format
  ###
  calculateProgress: (x) ->
    return ((x * @scale.x)  / (@width - (@knob.width * @scale.x))) * 100








module.exports = Slider