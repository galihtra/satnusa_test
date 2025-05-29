class CourseMaterial {
  final String title;
  final String youtubeUrl;
  final String duration;
  final double progress;

  CourseMaterial({
    required this.title,
    required this.youtubeUrl,
    required this.duration,
    required this.progress,
  });

  factory CourseMaterial.fromMap(Map<String, dynamic> map) {
    return CourseMaterial(
      title: map['title'],
      youtubeUrl: map['youtubeUrl'],
      duration: map['duration'],
      progress: map['progress']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'youtubeUrl': youtubeUrl,
      'duration': duration,
      'progress': progress,
    };
  }
}