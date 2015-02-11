# CoffeeScript


Polygon         = require './Graphics/Polygon.coffee'
Rectangle       = require './Graphics/Rectangle.coffee'
Renderer        = require './Graphics/Renderer.coffee'
Scene           = require './Graphics/Scene.coffee'
Text            = require './Graphics/Text.coffee'
graphics        = require './Graphics/Graphics.coffee'

# This class has a virtual method, that doesn't
# exist in the source but appears in the documentation.
#
# @method #set(key, value)
#   Sets a value on key
#   @param [Symbol] key describe key param
#   @param [Object] value describe value param
#
class Graphics

  @Polygon      = Polygon
  @Rectangle    = Rectangle
  @Renderer     = Renderer
  @Scene        = Scene
  @Text         = Text
  @graphics      = graphics
 
  
  # Requires the following json structure [[x,y,x2,y2][x,y,x2,y2]]
  @PolygonFromJSON: (json, skipRatio, scale) ->
    
    # How many coordinates to skip
    if not skipRatio?
      skipRatio = 5

    if not scale?
      scale = 
        x : 1,
        y : 1

    # Create a list of polygons
    polygonList = new Array
      
    # For each of the polygons
    for polygon, key in json
      # Create a point list
      pointList = new Array

      # Add a counter
      count = 0

      # And for all of the points in the polygon
      for point, _key  in polygon

        # Add every 20th point 
        if count++ % 5 == 0
          # Push this point to the point list
          pointList.push new PIXI.Point(point[0] / scale.x, point[1] / scale.y)
         
      # Add the polygon to the polygon list
      polygonList.push(new Gotham.Graphics.Polygon(pointList))
    return polygonList



  # Converts a Polygon into a Graphics element
  #
  # @example Convert list of polygons to list of Graphic objects
  #   graphicsList = Gotham.Graphics.PolygonToGraphics(polygonList)
  #
  # @example Convert a polygon to a graphics object
  #   graphicObj = Gotham.Graphics.PolygonToGraphics(polygon)
  #
  # @param [Array(Polygon) || Polygon] options the moving options
  #
  @PolygonToGraphics: (polygon, interactive) ->

    polygonList = []
    graphicsList = []
  
    if polygon.constructor != Array
      polygonList.push(polygon)
    else
      polygonList = polygon

    for polygon, key  in polygonList
      grp = new Gotham.Graphics.graphics()
      graphicsList.push grp
      grp.get().lineStyle(1, 0x0000FF, 1);
      grp.get().drawPolygon(polygon.points);

      if interactive?
        console.log "yes"
        grp.get().interactive = true
        grp.get().buttonMode = true
        grp.get().hitArea = new PIXI.Polygon(polygon.points);




    return graphicsList
      
      
      
      

  
  

module.exports = Graphics