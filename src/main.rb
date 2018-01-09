require 'json'

require "#{File.dirname(__FILE__)}/ant"
require "#{File.dirname(__FILE__)}/ant_colony"
require "#{File.dirname(__FILE__)}/location"
require "#{File.dirname(__FILE__)}/map"
require "#{File.dirname(__FILE__)}/map_state"
require "#{File.dirname(__FILE__)}/road"
require "#{File.dirname(__FILE__)}/io"
# TODO: Refactor roads (can we get rid of loc1, loc2?)
# refactor create_road / string parsing
ALPHA = 1.0
BETA = 1.0
RHO = 0.95
Q = 100.0

NUM_GENERATIONS = 10
COLONY_SIZE = 10

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
  colonies << AntColony.new(map, colony, COLONY_SIZE)
  map.roads.each do |road|
    road.pheromones[colony] = 50
  end
end

for cycle in 0..NUM_GENERATIONS
  output.write "\n\nGeneration #{cycle}...\n"
  for i in 0..COLONY_SIZE
    colonies.each do |colony|
      ants = colonies.map(&:ants).flatten
    end
    ants.each do |colony|
      ant = colony.ants[i]
      output.write("Colony #{colony.start} -> #{colony.goal}:\n")
      ant.travel
      output.write "Ant reached its goal after #{ant.tour_memory.size} steps!\n"
    end
    puts MapState.new(map, colonies).to_json
  end
  # at this point, every ant in every colony has a tour memory
  map.update_pheromones colonies
  colonies.each do |colony|
    colony = colony.restart
  end
end