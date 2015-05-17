

###*
# The network class is built ontop of SocketIO. Provides extra handling on connection and emits from rooms
# @class Network
# @module Framework
# @submodule Framework
# @namespace Gotham
# @constructor
# @param host {String} Hostname of the server
# @param port {Integer} Port of the server
###
class Network


  # Contstructor of the network class
  # Sets up required info to connect to server
  constructor: (host, port) ->
    ###*
    # The host to connect to
    # @property {String} host
    ###
    @host = host

    ###*
    # The port to connect on
    # @property {Number} port
    ###
    if not port ?
      @port = 8080
    else
      @port = port


    ###*
    # The Socket object
    # @property {SocketIO} Socket
    ###
    @Socket = null

    ###*
    # Variable which determine if the socket has been connected once.
    # @property {Boolean} hasConnectedOnce
    # @private
    ###
    @hasConnectedOnce = false

    ###*
    # Callback for when the client has connected
    # @method onConnect
    ###
    @onConnect = ->

    ###*
    # Callback for when the client has recconected
    # @method onReconnect
    ###
    @onReconnect = ->

    ###*
    # Callback for when the client is reconnecting
    # @method onReconnecting
    ###
    @onReconnecting = ->

    ###*
    # Callback for when the connection is lost
    # @method onDisconnect
    ###
    @onDisconnect = ->


  ###*
  # Connects to the server
  # @method connect
  ###
  connect: ->
    that = @

    @Socket = io.connect "#{@host}:#{@port}"
    @Socket.on 'connect', ->

      if that.hasConnectedOnce
        that.onReconnect @
      else
        that.onConnect @

      that.hasConnectedOnce = true


    # On reconnecting status
    @Socket.on 'reconnecting', ->
      that.onReconnecting @

    # On disconnecting status
    @Socket.on 'disconnect', ->
      that.onDisconnect @




module.exports = Network