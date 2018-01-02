class AntColony
  attr_accessor :ants
  
  def initialize(map, pheromone_flavor, size = 10)
    @ants = []
    start = map.get_random_location
    goal = map.get_random_location
    [0..size].each do |_|
      @ants << Ant.new(start, goal, pheromone_flavor, map)
    end
  end
end