class AntColony
  attr_reader :pheromone_flavor
  attr_accessor :ants
  
  def initialize(map, pheromone_flavor, size = 10)
    @ants = []
    start = map.get_random_location
    goal = map.get_random_location
    @pheromone_flavor = pheromone_flavor
    for i in 0..size
      @ants << Ant.new(start, goal, @pheromone_flavor, map)
    end
  end
end