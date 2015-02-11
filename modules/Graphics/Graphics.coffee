

class graphics

  constructor: ->
    @graphics = new PIXI.Graphics()
    @graphics.setScale = (num) ->


      #diffX = Math.abs(this.width - (this.width * num))
      #diffY = this.height - (this.height * num)
      console.log this


  get: ->
    return @graphics




    

module.exports = graphics
