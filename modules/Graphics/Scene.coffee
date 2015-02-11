# CoffeeScript


# Scene inherits {http://www.goodboydigital.com/pixijs/docs/classes/Stage.html PIXI.Stage}
#
# Stages are now Scenes which is now in a {http://en.wikipedia.org/wiki/Scene_graph Scene Graph} Structure
#
# See {http://www.goodboydigital.com/pixijs/docs/classes/Stage.html PIXI.Stage} for properties
#
class Scene extends PIXI.Stage

  # @param backgroundColor [Hex] Color in Hex format
  constructor : ->
    super

module.exports = Scene