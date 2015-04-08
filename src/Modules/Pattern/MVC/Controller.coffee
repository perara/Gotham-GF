


class Controller

  constructor: (View) ->
    # Create an instance of the View
    ViewObject = new View

    # Check that the ViewObject is an actual view
    if not ViewObject._v then throw Error "View is missing in super constructor (Have your view inherited GothamGame.View ?"

    @__created = false

    # Set the view property
    @View = ViewObject

  create: ->
    throw new Error "create() must be overriden"



module.exports = Controller