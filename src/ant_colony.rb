class AntColony
  attr_reader :pheromone_flavor, :start, :goal
  attr_accessor :ants
  
  def initialize(map, pheromone_flavor, size)
    @ants = []
    @size = size
    @start = map.get_random_location
    @goal = map.get_random_location
    @map = map
    @pheromone_flavor = pheromone_flavor
    for i in 0..size
      @ants << Ant.new(@start, @goal, @pheromone_flavor, map)
    end
  end

  def restart
    @ants = @ants.clear
    for i in 0..@size
      @ants << Ant.new(@start, @goal, @pheromone_flavor, @map)
    end 
  end
end