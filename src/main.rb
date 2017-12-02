require 'ant'
require 'ant_colony'
require 'location'
require 'map'
require 'road'

ALPHA = 1.0
BETA = 1.0
RHO = 0.95
Q = 100

def create_location(string)
  Location.new string
end

def create_road(string)
  loc1, loc2, distance = string.split('\t')
  Road.new loc1, loc2, distance
end

def process_input
  input = File.open('../input.txt', 'r')
  locations = Set.new
  roads = Set.new

  parsing_locations = true
  parsing_roads = false

  input.each_line do |line|
    if line.chomp == '#Roads'
      parsing_locations = false
      parsing_roads = true
      next
    end

    locations << create_location(line) && next if parsing_locations
    roads << create_road(line) && next if parsing_roads
  end
  Map.new locations, roads
end

map = process_input
output = File.open('../output.txt', 'w')