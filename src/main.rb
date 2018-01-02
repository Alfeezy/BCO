require "#{File.dirname(__FILE__)}/ant"
require "#{File.dirname(__FILE__)}/ant_colony"
require "#{File.dirname(__FILE__)}/location"
require "#{File.dirname(__FILE__)}/map"
require "#{File.dirname(__FILE__)}/road"
require 'set'

ALPHA = 1.0
BETA = 1.0
RHO = 0.95
Q = 100

def create_location(string)
  Location.new string
end

def create_road(string, locs)
  loc1, loc2, distance = string.split("\t")
  locs.each do |loc|
    if loc1.is_a?(Location) && loc2.is_a?(Location)
      return Road.new loc1, loc2, distance
    end
    if loc1.is_a?(String) && loc1.strip == loc.name.strip
      loc1 = loc
    elsif loc2.is_a?(String) && loc2.strip == loc.name.strip
      loc2 = loc
    end
  end
  nil
end

def process_input
  input = File.open('input.txt', 'r')
  locations = []
  roads = []

  parsing_locations = true
  parsing_roads = false

  input = input.read().split("#Roads\n")
  input[0].each_line do |line|
    locations << create_location(line) unless line.strip.empty?
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

[0..10].each do |colony|
  colonies << AntColony.new(map, colony)
  map.roads.each do |road|
    road.pheromones[colony] = 0
  end
end

[0..25].each do |cycle|
  colonies.each do |colony|
    pheromones = []
    should_print = true if colony == colonies.last
    colony.ants.each do |ant|
      pheromones << ant.move_around(should_print, output)
    end
  end
  map.update_pheromones pheromones, RHO
end