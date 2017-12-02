class Ant

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