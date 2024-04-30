import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apis/model/comments_model.dart';

import 'albums_dio.dart';

class SingleCommentsDio extends StatefulWidget {
  int id;

  SingleCommentsDio({required this.id});

  @override
  State<SingleCommentsDio> createState() => _SingleCommentsDio();
}

class _SingleCommentsDio extends State<SingleCommentsDio> {
  late int id;
  CommentsModel? model;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    getSinglePostCommentsApi(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Single Comments"),
      ),
      body: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            if (model != null) {
              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AlbumsDio(id: id)));
                  },
                  child: ListTile(
                    title: Text(model!.id.toString()),
                    subtitle: Text(model!.body),
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

  Future<void> getSinglePostCommentsApi(int id) async {
    final dio = Dio();
    try {
      final response = await dio.get(
        'https://jsonplaceholder.typicode.com/comments/$id',
      );
      if (response.statusCode == 200) {
        print(response.data);
        setState(() {
          model = CommentsModel.fromJson(response.data);
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
