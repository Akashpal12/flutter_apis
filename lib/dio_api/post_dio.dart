import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../model/post_model.dart';

class PostDioApi extends StatefulWidget {
  const PostDioApi({super.key});

  @override
  State<PostDioApi> createState() => _PostDioApiState();
}

class _PostDioApiState extends State<PostDioApi> {
  List<PostModel> postList = [];

  @override
  void initState() {
    getPostApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: postList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(postList[index].title),
            subtitle: Text(postList[index].body),
          );
        },
      ),
    );
  }

  Future<void> getPostApi() async {
    final dio = Dio();
    try {
      final response = await dio.get(
        'https://jsonplaceholder.typicode.com/posts',
      );
      if (response.statusCode == 200) {
        setState(() {
          postList = (response.data as List)
              .map((json) => PostModel.fromJson(json))
              .toList();
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
