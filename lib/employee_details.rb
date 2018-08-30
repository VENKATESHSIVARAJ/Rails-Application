class EmployeeDetails
	def initialize(id, user_id, firstname, lastname, role)
		@id = id
		@user_id = user_id
		@firstName = firstname
		@lastName = lastname
		@role = role
	end

	def id
		@id
	end
	def user_id
		@user_id
	end
	def firstName
		@firstName
	end
	def lastName
		@lastName
	end
	def role
		@role
	end
end
