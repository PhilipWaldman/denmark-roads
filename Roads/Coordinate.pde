class Coordinate {

  final float latitude, longitude; // degrees
  final float altitude; // meters

  Coordinate(float lat, float lon, float alt) {
    latitude = lat;
    longitude = lon;
    altitude = alt;
  }
  
  String toString(){
    return "{lat:"+latitude+", lon:"+longitude+", alt:"+altitude+"}";
    //return "-";
  }
}
