


# Control which adds Slider functionality to Gotham
#
# @example How to use the slider
#     slider = new Gotham.Controls.Slider
#     stage.addChild slider
#
class Slider extends Gotham.Graphics.Sprite

  # Constructor Which Creates the Slider
  # The slider can then be configured as a regular sprite
  # @param [Gotham.Texture] knobTexture Texture of the knob
  # @param [Gotham.Texture] background Texture of the slider background
  constructor: (knobTexture, background) ->
    super
    that = @

    @onProgress = null
    @progress = 0

    @texture = background
    @tint = 0xFFFF00


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
    knob.mousedown = knob.touchstart = (data) ->
      @data = data
      @sx = data.getLocalPosition(@).x * @scale.x;
      @dragging = true

    # Deactivate dragging and reset data
    knob.mouseup = knob.mouseupoutside = knob.touchend = knob.touchendoutside = (data) ->
      @data = null
      @dragging = false

    # Check if user is dragging, Then move the knob accordingly
    knob.mousemove = knob.touchmove = (data) ->
      if @dragging
        newData = @data.getLocalPosition(@parent)
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


  # Calculates Current slider percentage based on knob's position
  # Accounts for scale and all that jazz
  # @param [Integer] x Knob's current X position
  calculateProgress: (x) ->
    return ((x * @scale.x)  / (@width - (@knob.width * @scale.x))) * 100








module.exports = Slider