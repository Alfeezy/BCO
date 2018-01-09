class Road
  attr_reader :loc1, :loc2, :distance
  attr_accessor :pheromones

  # constructs new road object
  # precondition: parameters are gucci
  def initialize(loc1, loc2, distance)
		@loc1 = loc1
	  @loc2 = loc2
		@distance = distance
		@pheromones = {}
	end

	# compares two roads to see if they are equal
	# Returns: boolean describing if roads are equals
	def ==(other)
		eq = [loc1, loc2].permutation.map {|a| a == [other.loc1, other.loc2] }
		eq.include? true
	end

	# returns String representation of this road 
	def to_s
		"Road: #{@loc1} <--> #{@loc2}, distance = #{@distance}"
	end

	def to_hash
		{ destinations: [@loc1, @loc2], distance: @distance }
	end

	def to_hash_with_pheromone
		to_hash.merge pheromones: @pheromones
	end

	def to_json(with_pheromone, *args)
		(with_pheromone ? to_hash_with_pheromone : to_hash).to_json(*args)
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