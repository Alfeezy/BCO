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

  def update_pheromones(colonies)
    colonies.each do |colony|
      colony.ants.each do |ant|
        ant.lay_pheromone
      end
    end
  end

  def get_random_location
    @locations.sample
  end

  def find_road(loc1, loc2)
    new_road = Road.new(loc1, loc2, 0)
    @roads.each do |r|
      return r if new_road == r
    end
    nil
  end
end