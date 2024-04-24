import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_apis/model/post_model.dart';
import 'package:http/http.dart' as http;

class PostHttpApi extends StatefulWidget {
  const PostHttpApi({Key? key}) : super(key: key);

  @override
  State<PostHttpApi> createState() => _PostHttpApiState();
}

class _PostHttpApiState extends State<PostHttpApi> {
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
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );
      if (response.statusCode == 200) {
        print('response is successful');
        List<dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          postList = jsonResponse.map((json) => PostModel.fromJson(json)).toList();
        });
      } else {
        print('response is Failed');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
