
# Sprite class which inherits PIXI.Sprite
#
class Sprite extends PIXI.Sprite

  # Constructor which also adds a hoverTexture element to Gotham.Sprite
  #
  constructor: (texture) ->
    super

    @hoverTexture = null
    @normalTexture = texture



module.exports = Sprite