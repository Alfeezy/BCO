=begin
Name: Bastien Gliech
Scrum: Lord
Peak: Ballmer's
=end


class Road
  # constructs new road object
  # precondition: parameters are gucci
  def initialize(loc1, loc2, distance, pheromone)
		@loc1 = loc1
	  @loc2 = loc2
		@distance = distance
		@pheromone = pheromone
	end
	attr_reader :loc1, :loc2

	# compares two roads to see if they are equal
	# Returns: boolean describing if roads are equals
	def ==(road2)
		# uses location class equals method (TODO)
		road2.loc2 == loc1 && road2.loc1 == loc2
	end

	# evaporates pheomone on this road, in accordance to 
	def evap_pheromone(evapRate)
		pheromone *= evapRate
	end

	# returns String representation of this road 
	def to_s
		"Road: #{@loc1} <--> #{@loc2}, distance = #{@distance}"
	end

	# Precondition: location l is at one end of this road
	# Returns: Location at other end
	def other_loc(location)
		# uses location class equals method (TODO)
		if location == loc1
			loc2
		else
			loc1
		end
	end
end