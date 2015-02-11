


class Text extends PIXI.Text

  # TODO
  constructor: (text, style, x, y)->
    super
    @setText(text)
    @position.x = x
    @position.y = y
    if style?
      @setStyle(style)
 
    


module.exports = Text