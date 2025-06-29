class DownloadedVideoModel {
  final int? id; // Unique identifier for the video
  final String videoId;
  final String title;
  final String thumbnailUrl;
  final String videoUrl;
  final int duration; // Duration in seconds
  final DateTime downloadDate;
  final double progress; // Optional field for download progress

  DownloadedVideoModel({
    this.id, // Optional ID for the database
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
    required this.downloadDate,
    required this.progress,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Include ID if available
      'video_id': videoId,
      'title': title,
      'thumbnail_url': thumbnailUrl,
      'video_url': videoUrl,
      'duration': duration,
      'progress': progress, // Default to 0.0 if not provided
      'download_date': downloadDate.toIso8601String(),
    };
  }

  factory DownloadedVideoModel.fromJson(Map<String, dynamic> json) {
    return DownloadedVideoModel(
      videoId: json['video_id'],
      title: json['title'],
      id: json['id'], // Optional ID from JSON
      thumbnailUrl: json['thumbnail_url'],
      videoUrl: json['video_url'],
      duration: json['duration'],
      progress: json['progress'].toDouble(), // Convert to double if present
      downloadDate: DateTime.parse(json['download_date']),
    );
  }
}
