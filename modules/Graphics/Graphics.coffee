
class Graphics extends PIXI.Graphics

  constructor: ->
    super
    @_dx = 0
    @_dy = 0


  redraw: ->
    @clear()
    @graphics()

  graphics: ->
    throw new Error "Override this function"


module.exports = Graphics