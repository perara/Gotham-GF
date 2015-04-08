


class Controller

  constructor: (View, name) ->
    # Create an instance of the View
    ViewObject = new View

    # Check that the ViewObject is an actual view
    if not ViewObject._v then throw Error "View is missing in super constructor (Have your view inherited GothamGame.View ?"

    @_created = false
    @_processes = []
    @name = name

    # Set the view property
    @View = ViewObject

    # Initiate Network Component
    @__network = null



  # This function should be overriden, It creates the controller
  #
  #
  create: ->
    throw new Error "create() must be overriden"

  # Adds a process which is executed in the game loo
  #
  #
  addProcess: (func) ->
    @_processes.push func

  # Sets the network module
  #
  # @param network {Gotham.Network} Network module
  #
  setNetwork: (network) ->
    console.log network
    console.log @name
    @__network = network.connection[@name.camelCase()]


  # Gets the network module
  #
  # @return {Gotham.Network} Network module
  getNetwork: ->
    return @__network


  addNetworkListener: (event, callback) ->
    @__network[event] = callback


  # Adds a client side callback which can be used serverside of signalR
  # @param name {String} Name of the callback
  # @param callback {Callback} Callback function
  addNetworkCallback: (name , callback) ->
    @__network.client[name] = callback


module.exports = Controller