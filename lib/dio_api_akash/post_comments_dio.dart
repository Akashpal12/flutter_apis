import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apis/dio_api_akash/single_comments_dio.dart';

import '../model/comments_model.dart';

class PostCommentsDio extends StatefulWidget {
  int id;

  PostCommentsDio({super.key, required this.id});

  @override
  State<PostCommentsDio> createState() => _PostCommentsDioState();
}

class _PostCommentsDioState extends State<PostCommentsDio> {
  late int id;
  List<CommentsModel> commentsList = [];

  @override
  void initState() {
    super.initState();
    id = widget.id;
    getPostCommentsApi(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Comments'),
      ),
      body: ListView.builder(
          itemCount: commentsList.length,
          itemBuilder: (context, index) {
            if (!commentsList.isEmpty) {
              return Card(
                elevation: 10,
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SingleCommentsDio(id: id)));
                  },
                  child: SizedBox(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(" Id : ${commentsList[index].id}"),
                          SizedBox(
                            height: 2,
                          ),
                          Text("Post Id : ${commentsList[index].postId}"),
                          SizedBox(
                            height: 2,
                          ),
                          Text(" Name : ${commentsList[index].name}"),
                          SizedBox(
                            height: 2,
                          ),
                          Text(" Email : ${commentsList[index].email}"),
                          SizedBox(
                            height: 2,
                          ),
                          Text(" Body : ${commentsList[index].body}")
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
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
          commentsList = (response.data as List)
              .map((json) => CommentsModel.fromJson(json))
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
