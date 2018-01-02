class Map
  attr_accessor :locations, :roads, :total_distance, :alpha, :beta, :rho, :q

  def initialize(locations, roads, alpha, beta, rho, q)
    @locations = locations
    @roads = roads
    @total_distance = 0
    @alpha = alpha
    @beta = beta
    @rho = rho
    @q = q

    @locations.each do |l|
      l.add_roads(@roads)
    end
  end

  def ant_storage
    bus_routes = Hash[@roads.map {|x| [x, 0]}]
    @locations.each do |location|
      location.ants.each do |ant|
        bus_routes[ant.next_road] += 1
      end
    end
    bus_routes
  end

  def bus_distance 
    ant_storage.each do |key, val|
      total_distance += key.distance * ((val + 19) / 20)
    end
  end

  def update_pheromones(pheromones, rho)
    pheromones.each do |road, pheromone|
      road.pheromone += pheromone
      road.pheromone *= rho
    end
  end

  def get_random_location
    @locations.sample
  end
end