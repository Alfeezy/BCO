require 'json'

require "#{File.dirname(__FILE__)}/ant"
require "#{File.dirname(__FILE__)}/ant_colony"
require "#{File.dirname(__FILE__)}/location"
require "#{File.dirname(__FILE__)}/map"
require "#{File.dirname(__FILE__)}/road"
require "#{File.dirname(__FILE__)}/io"
# TODO: Refactor roads (can we get rid of loc1, loc2?)
# refactor create_road / string parsing
ALPHA = 1.0
BETA = 1.0
RHO = 0.95
Q = 100.0

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

map = process_input
colonies = []
states = []
output = File.open('output.txt', 'w')

for colony in 0..10
  colonies << AntColony.new(map, colony)
  map.roads.each do |road|
    road.pheromones[colony] = 50
  end
end

for cycle in 0..10
  output.write "\n\n\nGeneration #{cycle}...\n"
  colonies.each do |colony|
    should_print = true if colony == colonies.last
    colony.ants.each_with_index do |ant, ix|
      ant.travel(should_print, output)
      output.write("Ant reached its goal (#{ant.start} -> #{ant.goal}) after #{ant.tour_memory.size} steps!\n")
    end
  end
  # at this point, every ant in every colony has a tour memory
  map.update_pheromones colonies
  colonies.each do |colony|
    colony = colony.restart
  end
end