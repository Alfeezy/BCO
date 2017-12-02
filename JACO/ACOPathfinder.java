/*
Name: Jarred Durant
Course: CIS 421 -- Artificial Intelligence
Instructor: Dr. Laura Grabowski
Assignment #4 -- Pathfinding in Middle-Earth with Ant Colony Optimization
*/

import java.util.*;
import java.io.*;

public class ACOPathfinder {
  public static final double ALPHA = 1.0; // weight of pheromone
  public static final double BETA = 1.0;  // weight of heuristic
  public static final double RHO = 0.95;  // trail persistence: 1 - RHO = evap
  public static final int Q = 100;        // quantity of pheromone to distribute

  public static HashSet<Location> locations;
  public static HashSet<Road> roads;
  public static Location startingLocation;
  public static final String goalLoc = "Iron Hills";
	public static int opCode;
  public static boolean print;
  public static PrintStream out;

  public static void main(String[] args) throws FileNotFoundException {
    processInput();
		menu();
    out = new PrintStream(new FileOutputStream("output.txt", true));
    // 25 cycles
    for (int cycle = 0; cycle < 25; cycle++) {
      ArrayList<Map<Road, Double>> pheromones = new ArrayList<Map<Road, Double>>();
      // 10 ants per cycle
      
      for (int antNo = 0; antNo < 10; antNo++) {
        Ant a = new Ant(startingLocation, ALPHA, BETA, RHO, Q);
      
        if (cycle == 24 && antNo == 9) print = true;
      
        a.moveAround(print);
        pheromones.add(a.pheromoneToLay);
        for (Location l : locations) l.visited = false;
      }
      
      for (Road r : roads) r.evapPheromone(1 - RHO);
      
      for (Map<Road, Double> antPheromones : pheromones) {
        for (Road r : antPheromones.keySet()) {
          r.pheromone += antPheromones.get(r);
        }
      }
    }
  }

	// Presents the user with a menu to choose starting location and heuristic.
	// Postcondition: startingLocation is set
	public static void menu() {
		Scanner console = new Scanner(System.in);
		System.out.println("This program will provide a path from any location in");
		System.out.println("Middle-Earth to the Iron Hills. Please select a");
		System.out.println("starting location.");
		int locationNo = 1;
		for (Location l : locations) {
			System.out.println(locationNo + ".) " + l.name);
			l.id = locationNo;
			locationNo++;
		}
		int input = console.nextInt();
		for (Location l : locations) {
			if (input == l.id) {
				startingLocation = l;
				break;
			}
		}
		if (startingLocation == null) {
			System.err.println("Enter a valid number!");
			System.exit(0);
		}
	}

	// Takes an input file, makes a bunch of Location and Road files based on it.
	// Precondition: input.txt exists and is formatted correctly.
  public static void processInput() throws FileNotFoundException {
    Scanner fileScn = new Scanner(new File("input.txt"));
    boolean readLocs = true;
    roads = new HashSet<Road>();
    locations = new HashSet<Location>();
    while (fileScn.hasNextLine()) {
      String line = fileScn.nextLine();
      if (line.equals("#Roads")) {
        readLocs = false;
        continue;
      } if (readLocs) {
        String name = line.substring(0, line.indexOf('\t'));
        int distanceFromIronHills = Integer.parseInt
                                       (line.substring(line.indexOf('\t') + 1));
        Location l = new Location(name, distanceFromIronHills);
        locations.add(l);
      } else {
        String[] roadInfo = line.split("\t");
        for (Location l : locations) {
          if (l.name.equals(roadInfo[0]) || l.name.equals(roadInfo[1])) {
            Road r = new Road(roadInfo);
            l.addRoad(r);
            roads.add(r);
          }
        }
      }
    }
  }
}
