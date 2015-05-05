
###*
# The database utilizes lokiJS. Contains storage for all tables and easy to retrieve them when needed.
# @class Database
# @module Framework
# @submodule Framework
# @namespace Gotham
###
class Database

  # Creates a new database instance
  # @return [Database] Returns the database
  #
  constructor: ->
    @db = new loki()
    @_tables = {}
    return @

  # Creates a new table
  # This table is then stored in the internal _tables object
  # @return [TaffyDB] Returns the table
  #
  table: (tableName) ->
    if not @_tables[tableName]
      @_tables[tableName] = @db.addCollection(tableName, { indices: ['id'] })
    return @_tables[tableName]

  getTables: ->
    return @_tables
module.exports = Database