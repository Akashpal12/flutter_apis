class UserData {
  String name;
  int age;
  String imageUrl;

  UserData({required this.name, required this.age, required this.imageUrl});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'imageUrl': imageUrl,
    };
  }
  factory UserData.fromJson(Map<dynamic, dynamic> json) {
    return UserData(
      name: json['name'] as String,
      age: json['age'] as int,
      imageUrl: json['imageUrl'] as String,
    );
  }
}