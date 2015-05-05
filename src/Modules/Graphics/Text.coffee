

###*
# Text class which inherits PIXI.Text
# @class Text
# @module Framework
# @submodule Framework.Graphics
# @namespace Gotham.Graphics
# @extends PIXI.Text
# @constructor
# @param text {String} the text string
# @param [style] {Object} The style parameters
# @param [style.font] {String} default 'bold 20px Arial' The style and size of the font
# @param [style.fill='black'] {String|Number} A canvas fillstyle that will be used on the text e.g 'red', '#00FF00'
# @param [style.align='left'] {String} Alignment for multiline text ('left', 'center' or 'right'), does not affect single line text
# @param [style.stroke] {String|Number} A canvas fillstyle that will be used on the text stroke e.g 'blue', '#FCFF00'
# @param [style.strokeThickness=0] {Number} A number that represents the thickness of the stroke. Default is 0 (no stroke)
# @param [style.wordWrap=false] {Boolean} Indicates if word wrap should be used
# @param [style.wordWrapWidth=100] {Number} The width at which text will wrap, it needs wordWrap to be set to true
# @param [style.dropShadow=false] {Boolean} Set a drop shadow for the text
# @param [style.dropShadowColor='#000000'] {String} A fill style to be used on the dropshadow e.g 'red', '#00FF00'
# @param [style.dropShadowAngle=Math.PI/4] {Number} Set a angle of the drop shadow
# @param [style.dropShadowDistance=5] {Number} Set a distance of the drop shadow
# @param x {Number} X Coordinate
# @param y {Number} Y Coordinate
###
class Text extends PIXI.Text

  # Constructs the object, Calling the super constructor
  constructor: (text, style, x, y)->
    super
    @text = text
    @position.x = x
    @position.y = y

    if style?
      @style = style
 
    


module.exports = Text