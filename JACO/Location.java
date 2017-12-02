/*
Name: Jarred Durant
Course: CIS 421 -- Artificial Intelligence
Instructor: Dr. Laura Grabowski
Assignment #3 -- Pathfinding in Middle-Earth with A*
*/

import java.util.*;

public class Location implements Comparable<Location> {
  public int distanceFromIronHills;
  public HashSet<Road> connections;
  public String name;
  public boolean visited;
	public int fn;
	public int id;

  // Comparison method, using names
  public int compareTo(Location other) {
    return name.compareTo(other.name);
  }

	// create a new Location object
  public Location(String inName, int inDistance) {
    name = inName;
    distanceFromIronHills = inDistance;
    connections = new HashSet<Road>();
    visited = false;
  }

	// setter for f(n)
	public void setFN(int newF) { fn = newF; }

	// adds a road r to Location's connections sets
  public void addRoad(Road r) { connections.add(r); }

  // prints all of the roads this Location is connected to.
	// Not used in final program -- used for debugging.
  public String displayRoads() {
    String s = "";
    for (Road r : connections) {
      s += r.toString() + "\n";
    }
    return s;
  }

  // returns name of Location
  public String toString() { return name; }
}
