

# Text class which inherits PIXI.Text
#
class Text extends PIXI.Text

  # Constructs the object, Calling the super constructor
  constructor: (text, style, x, y)->
    super
    @setText(text)
    @position.x = x
    @position.y = y
    if style?
      @setStyle(style)
 
    


module.exports = Text