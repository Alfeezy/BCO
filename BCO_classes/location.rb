class Location
  attr_accessor :connections, :name, :visited, :fn, :id

  def initialize(name)
    @name = name
    @connections = Set.new
    @visited = false
  end

  def ==(other)
    @name == other.name
  end

  def to_s
    @name
  end

  def add_road(road)
    @connections << road
  end

  def display_roads
    s = ""
    @connections.each do |road|
      s += road.to_s + "\n"
    end
    s
  end
  
end