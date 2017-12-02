=begin
Name: Bastien Gliech
Scrum: Lord
Peak: Ballmer's
=end


class Road

	# constructs new road object
	# Precondition: params hash is formatted correctly
	def initialize(params)
		@loc1 = params[:loc1]
		@loc2 = params[:loc2]
		@distance = params[:distance]
		@pheremone = params[:pheremone]
	end
	attr_reader :loc1, :loc2

	# compares two roads to see if they are equal
	# Returns: boolean describing if roads are equals
	def equals(road2)

		# uses location class equals method (TODO)
		road2.loc2.equals(loc1) && road2.loc1.equals(loc2)
	end

	# evaporates pheremone on this road, in accordance to 
	def evapPheremone(evapRate)
		pheremone *= evapRate
	end

	# returns String representation of this road 
	def inspect
		puts "Road: #{@loc1} <--> #{@loc2}, distance = #{@distance}"
	end

	# Precondition: location l is at one end of this road
	# Returns: Location at other end
	def otherLoc(location)

		# uses location class equals method (TODO)
		if location.equals(loc1)
			loc2
		else
			loc1
		end
	end
end