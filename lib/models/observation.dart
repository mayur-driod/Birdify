/// A saved bird sighting observation.
class Observation {
  const Observation({
    required this.id,
    required this.birdName,
    required this.scientificName,
    required this.description,
    required this.habitat,
    required this.conservationStatus,
    required this.date,
    this.imagePath,
  });

  final String id;
  final String birdName;
  final String scientificName;
  final String description;
  final String habitat;
  final String conservationStatus;
  final DateTime date;

  /// Absolute path to the local captured image, if any.
  final String? imagePath;
}
