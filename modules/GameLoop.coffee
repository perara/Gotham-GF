

# This class is a game loop manager for the library.
#
# All classes that need a update loop needs to call  TODO
class GameLoop



  constructor: (fps) ->
    if not fps?
      @fps = 60
    else
      @fps = fps
    setInterval(@update, @fps)


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