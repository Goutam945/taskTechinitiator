class PostModel {
  final String id;
  final String message;
  final String username;
  final DateTime timestamp;

  PostModel({required this.id, required this.message, required this.username, required this.timestamp});

  Map<String, dynamic> toJson() => {
    'id': id,
    'message': message,
    'username': username,
    'timestamp': timestamp.toIso8601String(),
  };

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      message: json['message'],
      username: json['username'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
