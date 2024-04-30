import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

import '../model/post_model.dart';

class SinglePostHttps extends StatefulWidget {
  const SinglePostHttps({super.key});

  @override
  State<SinglePostHttps> createState() => _SinglePostHttpsState();
}

class _SinglePostHttpsState extends State<SinglePostHttps> {
  PostModel? postModel;

  @override
  void initState() {
    super.initState();
    getSinglePostApi();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Card(
        child: SizedBox(
          height: 200,
          child: InkWell(
            onTap: (){

            },
            child: Center(),
          ),
        ),
      ),
    );
  }
  Future<void> getSinglePostApi() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        setState(() {
          postModel = PostModel.fromJson(responseData);
          print(' Body : ${postModel?.body}');
        });

      } else {
        print('response is Failed');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
