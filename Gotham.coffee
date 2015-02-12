# CoffeeScript

# Third Party
window.Howler      =     require "./dependencies/howler.js"
window.PIXI       =     require './dependencies/pixi.js'


# 
Sound       =     require "./modules/Sound.coffee" 
Tween       =     require "./modules/Tween.coffee"
Graphics    =     require "./modules/Graphics.coffee"
Preload     =     require "./modules/Preload.coffee"
GameLoop    =     require "./modules/GameLoop.coffee"
Util        =     require "./util/Util.coffee"


class Gotham
  constructor: ->
    window.Gotham = @

    # Modules
    @Sound = Sound
    @Graphics = Graphics
    @Tween = Tween
    @GameLoop = new GameLoop()
    @Preload = new Preload()
    @Util = Util




module.exports = new Gotham()

