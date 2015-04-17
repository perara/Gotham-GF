

# Text class which inherits PIXI.Text
#
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