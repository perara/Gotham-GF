
###*
# The database utilizes lokiJS. Contains storage for all tables and easy to retrieve them when needed.
# @class Database
# @module Framework
# @submodule Framework
# @namespace Gotham
# @constructor
# @chainable
###
class Database

  # Creates a new database instance
  constructor: ->

    ###*
    # The database instance (LokiJS)
    # @property db {LokiJS}
    # @private
    ###
    @db = new loki()

    ###*
    # Tables for the database
    # @property _tables {Object}
    # @private
    ###
    @_tables = {}


    return @

  ###*
  # Creates a new table
  # This table is then stored in the internal _tables object
  # @method table
  # @param tableName {String} The table name
  # @return [LokiJS] Returns the table
  ###
  table: (tableName) ->
    if not @_tables[tableName]
      @_tables[tableName] = @db.addCollection(tableName, { indices: ['id'] })
    return @_tables[tableName]

  ###*
  # Retrieve all tables
  # @method getTables
  # @return {Object} All objects
  ###
  getTables: ->
    return @_tables


module.exports = Database