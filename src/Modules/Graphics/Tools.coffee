

###*
# Graphicsl Tool class for customized data manipulation
# @class Tools
# @module Framework
# @submodule Framework.Graphics
# @namespace Gotham.Graphics
###
class Tools


  # Converts a json structure to a polygon
  # The supported format is the following:
  # @example JSON Format
  #   json = [[x,y,x2,y2][x,y,x2,y2]]
  #
  # @param [Object JSON] json The json object
  # @param [Integer] skipRatio The Skip frequency.
  # @param [Object] scale scale option
  # @option scale [Double] x The X axis scale
  # @option scale [Double] y The Y axis scale
  @polygonFromJSON: (json, skipRatio, scale) ->

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
  @polygonToGraphics: (polygon, interactive) ->

    # Create some empty arrays
    polygonList = []
    graphicsList = []

    # Check if input is array or only a polygon
    # add to polygonList if only an object
    # else set polygon array to polygonList (If array)
    if polygon.constructor != Array
      polygonList.push(polygon)
    else
      polygonList = polygon




    for polygon, key  in polygonList

      # Find Upmost X and Y in the point list
      xory = 0
      minX = 10000000
      minY = 10000000
      for point in polygon.points
        if xory++ % 2 == 0
          if point < minX
            minX = point
        else
          if point < minY
            minY = point



      # Draw Graphics element
      grp = new Gotham.Graphics.Graphics()
      grp.minX = minX
      grp.minY = minY
      graphicsList.push grp
      grp.lineStyle(2, 0x000000, 1);
      grp.beginFill(0xffffff, 1.0);
      grp.polygon = polygon
      grp.drawPolygon(polygon.points);

      # Set interactive if flag is true
      if interactive?
        grp.interactive = true
        grp.buttonMode = true
        grp.hitArea = new Gotham.Graphics.Polygon(polygon.points);

    # Return list of graphics elements
    return graphicsList


module.exports = Tools