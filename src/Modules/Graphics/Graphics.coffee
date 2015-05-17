

###*
# Graphics class which inherits PIXI.Graphics
# @class Graphics
# @module Framework
# @submodule Framework.Graphics
# @namespace Gotham.Graphics
# @extends PIXI.Graphics
# @constructor
###
class Graphics extends PIXI.Graphics

  # Constructs the Graphics element calling PIXI.Graphics Constructor
  # Also add Delta coordinates to the class
  constructor: ->
    super

    ###*
    # X offset
    # @property {Number} _dx
    ###
    @_dx = 0

    ###*
    # Y offset
    # @property {Number} _dy
    ###
    @_dy = 0


module.exports = Graphics