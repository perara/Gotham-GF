
# Database has the capabilities for storing data for an application
#
# Database utilizes TaffyDB as its engine, @see http://www.taffydb.com/workingwithdata
#
# @example Instantiate and use the class
#   db = new Gotham.Database()
#   db_animals = db.createTable "animals"
#   db_animals.insert {id: 1, name: "Horse"}
#   db_animals.insert {id: 1, name: "Cow"}
#   db_animals.insert {id: 1, name: "Dog"}
#
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