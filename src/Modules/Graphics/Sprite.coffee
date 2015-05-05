
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

    @hoverTexture = null
    @normalTexture = texture



module.exports = Sprite