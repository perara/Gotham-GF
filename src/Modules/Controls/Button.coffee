
###*
# Button Control. Predefined button which can be easily manipulated for custom stuff.
# @class Button
# @module Framework
# @submodule Framework.Controls
# @namespace Gotham.Controls
# @extends Gotham.Graphics.Sprite
# @constructor
# @param text {String} Text label of the button
# @param width {Number} Width of the button
# @param height {Number} Height of the button
# @param [options] {Object} Options of the button
# @param [options.toggle=true] {Boolean} Weither the button is a toggle button or click button
# @param [options.textSize=40] {Number} Size of the text label
# @param [options.texture=null] {Gotham.Graphics.Texture} Which texture to apply to the button
# @param [options.offset=0] {Number} Offset of the button in pixels
# @param [options.margin=0] {Number} Margin of the button
# @param [options.alpha=1] {Number} Alpha of the button (Between 0 an 1)
###
class Button extends Gotham.Graphics.Sprite

  # Constructors the button calling the super class of Gotham.Graphics.Sprite --> PIXI.Sprite
  constructor: (text, width, height, options) ->
    that = @

    # Option Parsing
    options = if not options? then {} else options
    _toggle = if options.toggle? then options.toggle else true
    _textSize = if options.textSize? then options.textSize else 40
    _texture = if options.texture? then options.texture else null
    _buttonColor = if options.buttonColor? then options.buttonColor else 0x000000
    _offset = if options.offset then options.offset else 0
    _margin = if options.margin then options.margin else 0
    _alpha = if options.alpha? then options.alpha else 1
    @margin = _margin

    if not _texture?
      _texture = new Gotham.Graphics.Graphics
      #_texture.lineStyle(1, 0xD3D3D3);
      _texture.beginFill _buttonColor, _alpha
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