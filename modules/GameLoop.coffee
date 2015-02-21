

# This class is a game loop manager for the library.
#
# All classes that need a update loop needs to call  TODO
class GameLoop



  constructor: (fps) ->
    if not fps?
      @fps = 1
    else
      @fps = fps

    #PIXI.INTERACTION_FREQUENCY = 60;
    that = @
    animate = ->
      requestAnimationFrame( animate );
      that.update()
    requestAnimationFrame animate


  methods =
      "logic" : []
      "draw" : []


  update: () ->
    for key, logic of methods["logic"]
      logic()

    for key, draw of methods["draw"]
      draw()


  addLogic: (method) ->
    methods["logic"].push(method)

  addDraw: (method) ->
    methods["draw"].push(method)




module.exports = GameLoop