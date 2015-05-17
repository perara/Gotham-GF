
###*
# Sprite class which extends PIXI Sprite. Includes a hover texture
# @class Sprite
# @module Framework
# @submodule Framework.Graphics
# @namespace Gotham.Graphics
# @extends PIXI.Sprite
# @constructor
# @param texture {Gotham.Graphics.Texture} The default texture
###
class Sprite extends PIXI.Sprite

  # Constructor which also adds a hoverTexture element to Gotham.Sprite
  #
  constructor: (texture) ->
    super

    ###*
    # Texture for when the sprite is hovered
    # @property {Gotham.Graphics.Texture}
    ###
    @hoverTexture = null

    ###*
    # Original texture
    # @property {Gotham.Graphics.Texture} normalTexture
    ###
    @normalTexture = texture
    @texture = texture



module.exports = Sprite