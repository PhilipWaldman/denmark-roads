// 3D Road Network (North Jutland, Denmark)
// https://archive.ics.uci.edu/ml/datasets/3D+Road+Network+%28North+Jutland%2C+Denmark%29

ArrayList<ArrayList<Coordinate>> roads;
float minLat=Float.MAX_VALUE, maxLat=Float.MIN_VALUE, 
  minLong=Float.MAX_VALUE, maxLong=Float.MIN_VALUE, 
  minAlt=Float.MAX_VALUE, maxAlt=Float.MIN_VALUE;

void setup() {
  fullScreen();
  background(0);
  init();
  noLoop();
}

void init() {
  final Table file = loadTable("3D_spatial_network.csv");
  roads = new ArrayList<ArrayList<Coordinate>>(); //[OSM_ID][Coordinate]

  int prevID = Integer.MIN_VALUE;
  for (int i=1; i<file.getRowCount(); i++) {
    TableRow cur = file.getRow(i);
    float curLong = cur.getFloat(1);
    float curLat = cur.getFloat(2);
    float curAlt = cur.getFloat(3);
    //float curAlt = 0;

    if (cur.getInt(0)!=prevID) {
      prevID=cur.getInt(0);
      roads.add(0, new ArrayList<Coordinate>());
    }
    roads.get(0).add(new Coordinate(curLat, curLong, curAlt));

    // -----------------------------------

    if (curLat<minLat)
      minLat=curLat;
    else if (curLat>maxLat)
      maxLat=curLat;

    if (curLong<minLong)
      minLong=curLong;
    else if (curLong>maxLong)
      maxLong=curLong;

    if (curAlt<minAlt)
      minAlt=curAlt;
    else if (curAlt>maxAlt)
      maxAlt=curAlt;
  }
}

void draw() {
  scale(1, -1);
  translate(0, -height);

  for (ArrayList<Coordinate> road : roads) {
    //stroke(random(255), random(255), random(255));

    for (int i=0; i<road.size()-1; i++) {
      Coordinate curCoord = road.get(i);
      Coordinate nextCoord = road.get(i+1);
      float col = map(road.get(i).altitude, minAlt, maxAlt, 0, 255);
      stroke(255-col, col, 0);

      PVector begin = new PVector();
      begin.x = map(curCoord.longitude, minLong, maxLong, 0, width);
      begin.y = map(curCoord.latitude, minLat, maxLat, 0, height);
      PVector end = new PVector();
      end.x = map(nextCoord.longitude, minLong, maxLong, 0, width);
      end.y = map(nextCoord.latitude, minLat, maxLat, 0, height);
      line(begin.x, begin.y, end.x, end.y);
    }
  }
}



/**
 String[] lines = loadStrings("https://archive.ics.uci.edu/ml/machine-learning-databases/00246/3D_spatial_network.txt");
 println("------------ DONE LOADING ---------------");
 println("there are " + lines.length + " lines");
 saveStrings("nums.txt", lines);
 println("------------ DONE SAVING ---------------");
 */
