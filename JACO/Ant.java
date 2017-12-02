/*
Name: Jarred Durant
Course: CIS 421 -- Artificial Intelligence
Instructor: Dr. Laura Grabowski
Assignment #4 -- Pathfinding in Middle-Earth with Ant Colony Optimization
*/

import java.util.*;

public class Ant {
  public static double ALPHA;   // weight of pheromone
  public static double BETA;    // weight of heuristic
  public static double RHO;     // trail persistence: 1 - RHO = evap
  public static int Q;          // quantity of pheromone to distribute
  // Ordered list of locations visited
  public static ArrayList<Location> tourMemory;
  // Map of how much pheromone to lay across each road.
  public static Map<Road, Double> pheromoneToLay = new TreeMap<Road, Double>();
  public static Location currentLoc;  // current location


  // Precondition: currentLoc is not null.
  // Postcondition: Move locations; currentLoc is added to tourMemory.
  public static void moveAround(boolean print) {
    while (!currentLoc.name.equals(ACOPathfinder.goalLoc)) {

      tourMemory.add(currentLoc);
      currentLoc = pickNextLocation();
      layPheromone();
      //currentLoc = next;
      if (print) ACOPathfinder.out.append(currentLoc.name + "\n");
      currentLoc.visited = true;
    }
  }

  // If we're "trapped" by being surrounded by visited locations, pretend we
  // never visited any surrounding locations.
  // Precondition: currentLoc is not null
  public static void recoverTrapped() {
      for (Road r : currentLoc.connections)
        r.otherLoc(currentLoc).visited = false;
  }

  // Probabilistically chooses the next location to move to, using the values of
  // ALPHA, BETA, and RHO in accordance with the Ant Colony Optimization
  // algorithm described in the text.
  // Precondition: currentLoc is not null
  public static Location pickNextLocation() {
    TreeMap<Location, Double> probabilities = new TreeMap<Location, Double>();
    double sigma = 0.0;
    for (Road r : currentLoc.connections) {
      if (r.otherLoc(currentLoc).name.equals(ACOPathfinder.goalLoc))
        return r.otherLoc(currentLoc);
      while (checkTrapped()) recoverTrapped();
      if (!r.otherLoc(currentLoc).visited) {
        double t = r.pheromone;
        t = Math.pow(t, ALPHA);
        double h = 1.0 / r.distance;
        h = Math.pow(h, BETA);
        sigma += t * h;
      }
    }

    for (Road r : currentLoc.connections) {
      if (!r.otherLoc(currentLoc).visited) {
        double t = r.pheromone;
        t = Math.pow(t, ALPHA);
        double h = 1.0 / r.distance;
        h = Math.pow(h, BETA);
        double prob = t * h / sigma;
        probabilities.put(r.otherLoc(currentLoc), prob);
      }
    }

    Random randGen = new Random();
    double rand = randGen.nextDouble();
    double runningTotal = 0;
    for (Location l : probabilities.keySet()) {
      runningTotal += probabilities.get(l);
      if (runningTotal > rand) return l;
    }

    Iterator<Location> i = probabilities.keySet().iterator();

    return i.next(); // should never happen
  }

  // Check to see if we're "trapped" (surrounded by visited locations)
  public static boolean checkTrapped() {
     for (Road r : currentLoc.connections) {
       if (!r.otherLoc(currentLoc).visited) return false;
     }
     return true;
  }

  // Lay pheromone across roads
  public static void layPheromone() {
    for (int i = 0; i < tourMemory.size() - 2; i++) {
      Location l1 = tourMemory.get(i);
      Location l2 = tourMemory.get(i + 1);
      Road r = null;
      for (Road thisRoad : ACOPathfinder.roads) {
        if ((thisRoad.loc1.equals(l1) && thisRoad.loc2.equals(l2))
                    || (thisRoad.loc1.equals(l2) && thisRoad.loc2.equals(l1))) {
          r = thisRoad;
          break;
        }
      }
      pheromoneToLay.put(r, (double) Q / tourMemory.size() - 1);
    }
  }

  // Constructor: self-explanatory, I hope
  public Ant(Location l, double inAlpha, double inBeta, double inRho, int inQ) {
    tourMemory = new ArrayList<Location>();
    currentLoc = l;
    ALPHA = inAlpha;
    BETA = inBeta;
    RHO = inRho;
    Q = inQ;
  }
}
