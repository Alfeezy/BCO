/*
Name: Jarred Durant
Course: CIS 421 -- Artificial Intelligence
Instructor: Dr. Laura Grabowski
Assignment #4 -- Pathfinding in Middle-Earth with Ant Colony Optimization
*/

public class Road implements Comparable<Road> {
  public Location loc1;     // One endpoint of the road (order doesn't matter)
  public Location loc2;     // Other endpoint of the road (order doesn't matter)
  public int distance;      // Length of road
  public int roadQuality;   // Quality of road. Not used in this assignment.
  public int riskLevel;     // Risk level of road. Not used in this assignment.
  public double pheromone;  // Pheromone level on road.

  // Comparison method. 
  public int compareTo(Road other) { return loc1.compareTo(other.loc1); }

	// Precondition: roadInfo is formatted correctly
	// Constructs a new Road object
  public Road(String[] roadInfo) {
    for (Location l : ACOPathfinder.locations) {
      if (roadInfo[0].equals(l.name)) loc1 = l;
      if (roadInfo[1].equals(l.name)) loc2 = l;
    }
    distance = Integer.parseInt(roadInfo[2]);
    roadQuality = Integer.parseInt(roadInfo[3]);
    riskLevel = Integer.parseInt(roadInfo[4]);
    pheromone = 15.0;
  }

  // Evaporate the pheromone on this road, in accordance with evapRate
  public void evapPheromone(double evapRate) {
    pheromone *= evapRate;
  }

	// returns String representation of Road
  public String toString() {
    return loc1.toString() + " <--> " + loc2.toString() + ": Distance = " + distance;
  }

	// Precondition: Location l is at one end of this road
	// Returns: The Location at the other end of the road from l
  public Location otherLoc(Location l) {
    if (l.equals(loc2)) return loc1;
    else return loc2;
  }
}
