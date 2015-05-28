require './helpers'

class Session
	def initialize(username, id, firstName, lastName, email)
    @username = username
    @id = id
    @firstName = firstName
    @lastName = lastName
    @email = email
end