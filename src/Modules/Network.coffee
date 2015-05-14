

###*
# The network class is built ontop of SocketIO. Provides extra handling on connection and emits from rooms
# @class Network
# @module Framework
# @submodule Framework
# @namespace Gotham
###
class Network


  # Contstructor of the network class
  # Sets up required info to connect to server
  #
  # @param [String] host Hostname of the server
  # @param [Integer] port Port of the server
  # @param [Domain] domain SignalR domain (For example: ws://test.com/domain
  constructor: (host, port) ->
    @host = host
    @port = port
    @Socket = @_socket = null

    @hasConnectedOnce = false

    @onConnect = ->
    @onReconnect = ->
    @onReconnecting = ->
    @onDisconnect = ->


    if not port ?
      @port = 8080
    else
      @port = port

  # Connects to the host returning onHubCallback when connected
  connect: ()->
    that = @

    @Socket = @_socket = io.connect "#{@host}:#{@port}"
    @_socket.on 'connect', ->

      if that.hasConnectedOnce
        that.onReconnect @
      else
        that.onConnect @

      that.hasConnectedOnce = true


    # On reconnecting status
    @._socket.on 'reconnecting', ->
      that.onReconnecting @

    # On disconnecting status
    @_socket.on 'disconnect', ->
      that.onDisconnect @




module.exports = Network