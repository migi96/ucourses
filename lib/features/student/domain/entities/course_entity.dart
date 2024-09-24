class Course {
  final String id;
  final String title;
  final String description;
  final String content;
  final String images;
  final double rating;
  final bool isArchived;
  final DateTime date; // Ensure this field is here
  final String? introVideo;
  final double? score;
  final String status; // Indicates if the course is a draft, published, etc.

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.images,
    required this.rating,
    required this.status,
    required this.isArchived,
    required this.date, // Ensure date is passed here
    this.introVideo,
    this.score,
  });
  Course copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    String? images,
    double? rating,
    bool? isArchived,
    DateTime? date,
    String? introVideo,
    double? score,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      isArchived: isArchived ?? this.isArchived,
      date: date ?? this.date,
      introVideo: introVideo ?? this.introVideo,
      score: score ?? this.score,
      status: status ?? status,
    );
  }
}
