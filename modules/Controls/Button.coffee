


# Class to create a button control
#
# @example How to use Button
#   button = Gotham.Controls.Button
#   button.onClick ->
#     console.log "Clicked"
#   parent.addChild button
#
class Button extends Gotham.Graphics.Sprite

  # Constructors the button calling the super class of Gotham.Graphics.Sprite --> PIXI.Sprite
  constructor: (text, width, height) ->
    that = @
    @_isToggled = false

    button_texture = new Gotham.Graphics.Graphics
    button_texture.lineStyle(1, 0xD3D3D3);
    button_texture.beginFill 0x000000
    button_texture.drawRect 0, 0, 100, 50
    button_texture.endFill()
    button_texture = button_texture.generateTexture()
    super button_texture


    @tint = 0x000000
    @width = width
    @height = height
    @setInteractive true

    # Create button text
    button_text = new Gotham.Graphics.Text(text, {font: "bold 40px Arial", fill: "#ffffff", align: "left"});
    button_text.position.x = (@width / @scale.x) / 2
    button_text.position.y = (@height / @scale.y) / 2
    button_text.width = @width / @scale.x
    button_text.height = @height / @scale.y
    button_text.anchor =
      x: 0.5
      y: 0.5
    @addChild button_text


    @click = (e) ->
      @_isToggled = !@_isToggled

      if @_isToggled
        @tint = 0xD3D3D3
        @toggleOn()
      else
        @tint = 0x000000
        @toggleOff()


  toggleOn: ->
  toggleOff: ->



module.exports = Button