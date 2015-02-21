# CoffeeScript
Renderer        = require './Renderer.coffee'
Scene           = require './Scene.coffee'

Polygon         = require './Graphics/Polygon.coffee'
Rectangle       = require './Graphics/Rectangle.coffee'
Text            = require './Graphics/Text.coffee'
GraphicsObj     = require './Graphics/Graphics.coffee'
Container       = require './Graphics/Container.coffee'
Texture         = require './Graphics/Texture.coffee'
Sprite          = require './Graphics/Sprite.coffee'


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
  @Graphics     = GraphicsObj
  @Container    = Container
  @Texture      = Texture
  @Sprite       = Sprite
 
  
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
        if count++ % skipRatio == 0
          # Push this point to the point list
          pointList.push new PIXI.Point(point[0] / (scale.x * 1.0), point[1] / (scale.y * 1.0))
         
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
      grp = new Gotham.Graphics.Graphics()
      graphicsList.push grp
      grp.lineStyle(1, 0x0000FF, 1);
      grp.beginFill(0xffffff, 0.5);
      grp.polygon = polygon
      grp.drawPolygon(polygon.points);

      if interactive?
        grp.interactive = true
        grp.buttonMode = true
        grp.hitArea = new Gotham.Graphics.Polygon(polygon.points);




    return graphicsList








module.exports = Graphics