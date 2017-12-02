class AntColony
  attr_accessor :ants
  
  def initialize(pheromone_flavor, size = 10)
    @ants = []
    start = get_random_location
    goal = get_random_location
    [0..size].each do |_|
      @ants << Ant.new(start, goal, pheromone_flavor)
    end
  end
end