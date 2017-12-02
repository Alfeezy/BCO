class Map

    def initialize(locations, roads)
        @locations = locations
        @roads = roads
    end

    def ant_storage
      bus_routes = []
      @locations.each do |location|
        location.ants.each do |ant|
          bus_routes << ant.next_road
        end
      end
    end

