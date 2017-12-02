class AntColony
  def initialize(size = 10, pheromone_flavor)
    @ants = []
    start = get_random_location
    goal = get_random_location
    [0..size].each do |_|
      @ants << Ant.new(start, goal, pheromone_flavor)
    end
  end
end