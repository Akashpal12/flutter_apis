import 'dart:convert';
import 'dart:js_interop';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apis/model/post_model.dart';

import '../model/comments_model.dart';
class PostCommentsDio extends StatefulWidget {
  int id;
  PostCommentsDio({super.key ,required this.id});

  @override
  State<PostCommentsDio> createState() => _PostCommentsDioState();
}

class _PostCommentsDioState extends State<PostCommentsDio> {
  late int id;
  List<CommentsModel> commentsList=[];

  @override
  void initState() {
    super.initState();
    id=widget.id;
    getPostCommentsApi(id);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }

  Future<void> getPostCommentsApi(int id) async {
    final dio = Dio();
    try {
      final response = await dio.get(
        'https://jsonplaceholder.typicode.com/posts/$id/comments',
      );
      if (response.statusCode == 200) {
        print(response.data);
        setState(() {
          commentsList=(response.data as List).map((json) => CommentsModel.fromJson(json)).toList();
        });

      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
