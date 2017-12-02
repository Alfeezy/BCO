class Map

  attr_accessor :locations, :roads, :total_distance

  def initialize(locations, roads)
    @locations = locations
    @roads = roads
    @total_distance = 0
  end

  def ant_storage
    bus_routes = Hash[@roads.map {|x| [x, 0]}]
    @locations.each do |location|
      location.ants.each do |ant|
        bus_routes[ant.next_road.id] += 1
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
end