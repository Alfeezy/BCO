class Ant
  attr_accessor :tour_memory, :goal, :current_location, :pheromone_flavor, 
                :pheromone_to_lay, :next_location

  def initialize(start, goal, pheromone_flavor, map)
    @tour_memory = []
    @goal = goal
    @current_location = start
    @next_location = nil
    @pheromone_flavor = pheromone_flavor
    @map = map
  end

  def move_around(should_print, out)
    while @current_location != @goal do
      @tour_memory << @current_location
      @next_location = pick_next_location

      # adds ant to next location, removes from current
      @next_location.connections << self
      @current_location.connections.delete(self)

      # changes current location to next
      @current_location = @next_location
      out.write @current_location.to_s if should_print
    end
    set_pheromones
  end

  def set_pheromones
    road = nil
    @tour_memory.each_with_index do |location_1, ix|
      location_2 = @tour_memory[ix + 1]
      road = map.find_road location, location_2 unless location_2.nil?
    end
    pheromones[road][@pheromone_flavor] = Q / @tour_memory.size - 1
    pheromones
  end

  def is_trapped?
    @current_location.connections.each do |road|
      return false unless road.other_loc(@current_location).visited
    end
  true
  end

  def recover_from_trap
    @current_location.connections.each do |road|
      road.other_loc(current_location).visited = false
    end
  end

  def pick_next_location
    probabilities = {}
    sigma = 0.0
    current_location.connections.each do |road|
      return goal if road.other_loc(current_location) == goal
      recover_trapped while is_trapped?
      unless road.other_loc(current_location).visited
        t = road.pheromones[pheromone_flavor] ** @map.alpha
        h = (1.0 / road.distance) ** @map.beta
        sigma += t * h
      end
    end

    current_location.connections.each do |road|
      unless road.other_loc(current_location).visited
        t = road.pheromones[pheromone_flavor] ** @map.alpha
        h = (1.0 / road.distance) ** @map.beta
        prob = t * h / (sigma + 0.0000001)
        probabilities[road.other_loc(current_location)] = prob
      end
    end

    rand = Random.rand
    running_total = 0
    probabilities.each do |loc, prob|
      puts loc.to_s + " " + prob.to_s
      running_total += prob
      return loc if running_total > rand
    end
  end
end