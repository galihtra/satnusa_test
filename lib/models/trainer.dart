class Trainer {
  final String name;
  final String title;
  final String imageUrl;

  Trainer({
    required this.name,
    required this.title,
    required this.imageUrl,
  });

  factory Trainer.fromMap(Map<String, dynamic> map) {
    return Trainer(
      name: map['name'],
      title: map['title'],
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'title': title,
      'imageUrl': imageUrl,
    };
  }
}