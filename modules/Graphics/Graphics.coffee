
class Graphics extends PIXI.Graphics

  constructor: ->
    super


  redraw: ->
    @clear()
    @graphics()

  graphics: ->
    throw new Error "Override this function"


module.exports = Graphics