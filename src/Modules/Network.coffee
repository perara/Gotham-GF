

# Network Class, Build atop of SignalR
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

    @onConnect = ->
    @onReconnect = ->
    @onReconnecting = ->


    if not port ?
      @port = 8080
    else
      @port = port

  # Connects to the host returning onHubCallback when connected
  #
  # @param [Callback] onHubCallback this callback is ran  when the hub info is retrieved. It then connects to the host
  connect: (callback)->
    that = @

    @Socket = @_socket = io.connect "#{@host}:#{@port}"
    @_socket.on 'connect', ->

      # Send onConnect callback
      that.onConnect(@)

      # Remove connect callback (dont want it to fire on reconnect)
      that.onConnect = ->

    @_socket.on 'reconnect', ->
      that.onReconnect(@)
    @_socket.on 'reconnecting', ->
      that.onReconnecting(@)




module.exports = Network