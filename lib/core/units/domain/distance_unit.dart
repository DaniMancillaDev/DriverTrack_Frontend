enum DistanceUnit {
  kilometers,
  miles;

  String get symbol {
    switch (this) {
      case DistanceUnit.kilometers:
        return 'km';
      case DistanceUnit.miles:
        return 'mi';
    }
  }
}
