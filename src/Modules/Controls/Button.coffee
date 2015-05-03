


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
  constructor: (text, width, height, options) ->
    that = @

    # Option Parsing
    options = if not options? then {} else options
    _toggle = if options.toggle? then options.toggle else true
    _textSize = if options.textSize? then options.textSize else 40
    _texture = if options.texture? then options.texture else null
    _offset = if options.offset then options.offset else 0
    _margin = if options.margin then options.margin else 0
    _alpha = if options.alpha? then options.alpha else 1
    @margin = _margin

    if not _texture?
      _texture = new Gotham.Graphics.Graphics
      #_texture.lineStyle(1, 0xD3D3D3);
      _texture.beginFill 0x000000, _alpha
      _texture.drawRect 0, 0, 100, 50
      _texture.endFill()
      _texture = _texture.generateTexture()

    super _texture


    @width = width
    @height = height
    @interactive =  true

    # Create button text
    button_text = new Gotham.Graphics.Text(text, {font: "bold #{_textSize}px Calibri", fill: "#ffffff", align: "left", dropShadow: true});
    button_text.position.x = ((@width / @scale.x) / 2) + _offset
    button_text.position.y = (@height / @scale.y) / 2
    button_text.width = @width / @scale.x
    button_text.height = @height / @scale.y
    button_text.anchor =
      x: 0.5
      y: 0.5
    @addChild button_text

    @label = button_text

    @click = (e) ->
      if not _toggle
        @onClick()
        return

      @_toggleState = !@_toggleState
      if @_toggleState
        @toggleOn()
      else
        @toggleOff()

  setBackground: (hex) ->
    @tint = hex

  onClick: ->
  toggleOn: ->
  toggleOff: ->



module.exports = Button