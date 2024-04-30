import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apis/dio_api_akash/post_comments_dio.dart';
import '../model/post_model.dart';

class SinglePostDio extends StatefulWidget {
  final int id;

  SinglePostDio({required this.id});

  @override
  State<SinglePostDio> createState() => _SinglePostDioState();
}

class _SinglePostDioState extends State<SinglePostDio> {
  late int id;
  PostModel? postModel;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    getSinglePostApi(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Single Post Api"),
      ),
      body: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            if (postModel != null) {
              return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PostCommentsDio(id: postModel!.id)));
                    },
                    child: ListTile(
                      title: Text(postModel!.title),
                      subtitle: Text(postModel!.body),
                    ),
                  ));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    ) ;
  }

  Future<void> getSinglePostApi(int id) async {
    final dio = Dio();
    try {
      final response = await dio.get(
        'https://jsonplaceholder.typicode.com/posts/$id',
      );
      if (response.statusCode == 200) {
        print(response.data);
        setState(() {
          postModel = PostModel.fromJson(response.data);
          //print(' Body ${postModel?.body}');
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
