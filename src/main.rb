require "#{File.dirname(__FILE__)}/ant"
require "#{File.dirname(__FILE__)}/ant_colony"
require "#{File.dirname(__FILE__)}/location"
require "#{File.dirname(__FILE__)}/map"
require "#{File.dirname(__FILE__)}/road"
# TODO: Refactor roads (can we get rid of loc1, loc2?)
# refactor create_road / string parsing
ALPHA = 1.0
BETA = 1.0
RHO = 0.95
Q = 100

def create_road(string, locs)
  loc1, loc2, distance = string.split("\t")
  locs.each do |loc|
    if loc1.is_a?(Location) && loc2.is_a?(Location)
      return Road.new loc1, loc2, distance.to_i    
    end
    if loc1.is_a?(String) && loc1.strip == loc.name.strip
      loc1 = loc
    end
    if loc2.is_a?(String) && loc2.strip == loc.name.strip
      loc2 = loc
    end
  end
  Road.new loc1, loc2, distance.to_i
end

def process_input
  input = File.open('input.txt', 'r')
  locations = []
  roads = []

  input = input.read().split("#Roads\n")
  input[0].each_line do |line|
    locations << Location.new(line)
  end

  input[1].each_line do |line|
    r = create_road(line, locations)
    roads << r unless line.strip.empty?
    roads = roads.compact
  end
  Map.new locations, roads, ALPHA, BETA, RHO, Q
end

map = process_input
should_print = false
output = File.open('output.txt', 'w')

colonies = []

for colony in 0..10
  colonies << AntColony.new(map, colony)
  map.roads.each do |road|
    road.pheromones[colony] = 50
  end
end

for cycle in 0..10
  colonies.each do |colony|
    should_print = true if colony == colonies.last
    colony.ants.each_with_index do |ant, ix|
      puts "Cycle #{cycle}, colony #{colony.pheromone_flavor}, ant #{ix}"
      ant.travel(should_print, output)
    end
  end
  # at this point, every ant in every colony has a tour memory
  map.update_pheromones colonies
  for colony in 0..10
    colonies[colony] = AntColony.new(map, colony)
  end
end