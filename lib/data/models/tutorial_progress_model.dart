class TutorialProgressModel {
  final String? id;
  final String userId;
  final String tutorialId;
  final double progress;
  final DateTime lastUpdated;
  final int durationWatched;

  TutorialProgressModel({
    this.id,
    required this.userId,
    required this.tutorialId,
    required this.progress,
    required this.lastUpdated,
    required this.durationWatched,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'tutorialId': tutorialId,
      'progress': progress,
      'lastUpdated': lastUpdated.toIso8601String(),
      'durationWatched': durationWatched,
    };
  }

  factory TutorialProgressModel.fromMap(Map<String, dynamic> map) {
    return TutorialProgressModel(
      id: map['id'],
      userId: map['userId'] ?? '',
      tutorialId: map['tutorialId'] ?? '',
      progress: (map['progress'] ?? 0.0).toDouble(),
      lastUpdated: DateTime.tryParse(map['lastUpdated'] ?? '') ??
          DateTime.now(), // fallback to now
      durationWatched: map['durationWatched'] ?? 0,
    );
  }
}
