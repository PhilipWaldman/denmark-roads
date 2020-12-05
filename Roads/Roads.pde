// 3D Road Network (North Jutland, Denmark)
// https://archive.ics.uci.edu/ml/datasets/3D+Road+Network+%28North+Jutland%2C+Denmark%29

ArrayList<ArrayList<Coordinate>> roads;
float minLat = Float.MAX_VALUE, maxLat = Float.MIN_VALUE;
float minLong = Float.MAX_VALUE, maxLong = Float.MIN_VALUE;
float minAlt = Float.MAX_VALUE, maxAlt = Float.MIN_VALUE;
float scale_factor = 500; // pixels per degree

void setup() {
  //fullScreen();
  background(0);
  noLoop();
}

void init() {
  final Table file = loadTable("3D_spatial_network.csv");
  roads = new ArrayList<ArrayList<Coordinate>>(); //[OSM_ID][Coordinate]

  int prevID = Integer.MIN_VALUE;
  for (int i = 1; i < file.getRowCount(); i++) {
    TableRow cur = file.getRow(i);
    int id = cur.getInt(0);
    float curLong = cur.getFloat(1);
    float curLat = cur.getFloat(2);
    float curAlt = cur.getFloat(3);

    if (id != prevID) {
      prevID = id;
      roads.add(0, new ArrayList<Coordinate>());
    }
    roads.get(0).add(new Coordinate(curLat, curLong, curAlt));

    // Find min or max latitude, longitude, and altitude

    if (curLat < minLat)
      minLat = curLat;
    else if (curLat > maxLat)
      maxLat = curLat;

    if (curLong < minLong)
      minLong = curLong;
    else if (curLong > maxLong)
      maxLong = curLong;

    if (curAlt < minAlt)
      minAlt = curAlt;
    else if (curAlt > maxAlt)
      maxAlt = curAlt;
  }
}

void settings() {
  init();
  // I don't know how to properly scale the lat and long to look perfect. This looks decent.
  size(int((maxLong - minLong) * scale_factor / 2), int((maxLat - minLat) * scale_factor));
}

void draw() {
  scale(1, -1);
  translate(0, -height);

  for (ArrayList<Coordinate> road : roads) {
    for (int i = 0; i < road.size() - 1; i++) {
      Coordinate curCoord = road.get(i);
      Coordinate nextCoord = road.get(i + 1);
      
      // red = low, green = high
      float col = map(curCoord.altitude, minAlt, maxAlt, 0, 255);
      stroke(255 - col, col, 0);

      PVector begin = new PVector();
      begin.x = map(curCoord.longitude, minLong, maxLong, 0, width);
      begin.y = map(curCoord.latitude, minLat, maxLat, 0, height);
      PVector end = new PVector();
      end.x = map(nextCoord.longitude, minLong, maxLong, 0, width);
      end.y = map(nextCoord.latitude, minLat, maxLat, 0, height);
      line(begin.x, begin.y, end.x, end.y);
    }
  }
  
  saveFrame("denmark.png");
}
