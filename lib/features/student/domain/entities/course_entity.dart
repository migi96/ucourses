class Course {
  final String id;
  final String title;
  final String description;
  final String content;
  final String images;
  final double rating;
  final double? score; // Optional score property

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.images,
    required this.rating,
    this.score, // Initialize as null by default
  });
}
