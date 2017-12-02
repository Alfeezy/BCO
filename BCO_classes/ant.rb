class Ant
  attr_accessor :tour_memory
  attr_accessor :goal
  attr_accessor :current_location
  attr_accessor :pheromone_flavor
  attr_accessor :pheromone_to_lay

  def initialize(start, goal, pheromone_flavor)
    @tour_memory = []
    @goal = goal
    @current_location = starting_location
    @pheromone_flavor = pheromone_flavor
  end

  def move_around(should_print, out)
    while @current_location != @goal do
      @tour_memory << @current_location
      @current_location = pick_next_location
      lay_pheromone
      out.write @current_location.to_s if should_print
    end
  end

  def lay_pheromone
    road = nil
    @tour_memory.each_with_index do |location_1, ix|
      location_2 = @tour_memory[ix + 1]
      road = Road.find_road location, location_2
    end
    pheromone_to_lay[road.to_s] = Q / @tour_memory.size - 1
  end

  def is_trapped?
    @current_location.connections.each do |road|
      return false unless road.other_location(@current_location).visited
    end
  true
  end

  def recover_from_trap
    @current_location.connections.each do |road|
      road.other_location(current_location).visited = false
    end
  end

  def pick_next_location
    # TODO. This will be different for bus
  end
end