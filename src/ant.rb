class Ant
  attr_accessor :tour_memory, :goal, :current_location, :pheromone_flavor

  def initialize(start, goal, pheromone_flavor, map)
    @tour_memory = []
    @goal = goal
    @current_location = start
    @next_location = nil
    @pheromone_flavor = pheromone_flavor
    @map = map
  end

  def travel(should_print, out)
    while @current_location != @goal do
      @tour_memory << @current_location
      @current_location = pick_next_location
     end
  end
  
  def lay_pheromone
    @tour_memory.each_with_index do |loc, ix|
      if ix < @tour_memory.size - 1
        loc2 = @tour_memory[ix + 1]
        road = @map.find_road loc, loc2
        road.pheromones[@pheromone_flavor] += Q / @tour_memory.size - 1
      end
    end
    puts "#{Q / @tour_memory.size - 1} over #{@tour_memory.size - 1} roads"
  end

  def is_trapped?
    @current_location.connections.each do |road|
      return false unless road.other_loc(@current_location).visited
    end
  true
  end

  def recover_from_trap
    puts "I'm in #{@current_location} - recovering from trap!"
    @current_location.connections.each do |road|
      road.other_loc(current_location).visited = false
    end
  end

  def pick_next_location
    probabilities = {}
    sigma = 0.0
    puts 'hashbrown' if @current_location.is_a? Hash
    @current_location.connections.each do |road|
      return goal if road.other_loc(current_location) == goal
      recover_trapped while is_trapped?
      unless road.other_loc(current_location).visited
        t = road.pheromones[pheromone_flavor] ** @map.alpha
        h = (1.0 / road.distance) ** @map.beta
        sigma += t * h
      end
    end

    @current_location.connections.each do |road|
      unless road.other_loc(current_location).visited
        t = road.pheromones[pheromone_flavor] ** @map.alpha
        h = (1.0 / road.distance) ** @map.beta
        prob = (t * h) / (sigma + 0.0000001)
        probabilities[road.other_loc(current_location)] = prob
      end
    end

    rand = Random.rand
    running_total = 0
    probabilities.each do |loc, prob|
      running_total += prob
      return loc if running_total > rand
    end
  end
end