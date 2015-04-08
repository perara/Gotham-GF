
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
    @tables = {}
    return @

  # Creates a new table
  # This table is then stored in the internal _tables object
  # @return [TaffyDB] Returns the table
  #
  createTable: (tableName) ->
    @tables[tableName] = Taffy.taffy()
    return @tables[tableName]

  # Creates a new table
  # This table is then stored in the internal _tables object
  # @return [TaffyDB] Returns the table
  #
  table: (tableName) ->
    try
      return @tables[tableName]
    catch
      throw new ReferenceError "No table exists with that name: '" + tableName + "'"


module.exports = Database