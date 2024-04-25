class CommentsModel {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  CommentsModel({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  factory CommentsModel.fromJson(Map<String, dynamic> json) {
    return CommentsModel(
      postId: json['postId'],
      id: json['id'],
      name: json['name'],
      email: json['email'],
      body: json['body'],
    );
  }
}
