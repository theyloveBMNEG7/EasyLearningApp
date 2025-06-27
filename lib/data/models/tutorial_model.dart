class Tutorial {
  final String id;
  final String title;
  final String videoUrl;
  final String image;
  final String type; // 'uploaded'
  final String? description;

  Tutorial({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.image,
    required this.type,
    this.description,
  });

  factory Tutorial.fromJson(Map<String, dynamic> json) {
    return Tutorial(
      id: json['id'],
      title: json['title'],
      videoUrl: json['video_url'],
      image: json['image'],
      type: json['type'],
      description: json['description'],
    );
  }
}
