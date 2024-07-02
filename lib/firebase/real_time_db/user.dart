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
}