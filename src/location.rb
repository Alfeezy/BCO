class Location

  attr_accessor :connections, :name, :visited

  def initialize(name)
    @name = name.strip
    @connections = []
    @visited = false
    @ants = []
  end

  def ==(other)
    @name == other.name
  end

  def to_s
    @name
  end

  def add_roads(roads)
    roads.each do |road|
      if self == road.loc1 or self == road.loc2
        @connections << road
      end
    end
  end

  def display_roads
    s = ""
    @connections.each do |road|
      s += road.to_s + "\n"
    end
    s
  end
  
end