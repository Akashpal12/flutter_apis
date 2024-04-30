import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apis/dio_api_akash/single_post_dio.dart';
import '../model/post_model.dart';

class PostDioNewApi extends StatefulWidget {
  const PostDioNewApi({super.key});

  @override
  State<PostDioNewApi> createState() => _PostDioApiState();
}

class _PostDioApiState extends State<PostDioNewApi> {
  List<PostModel> postList = [];


  @override
  void initState() {
    getPostApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Api"),
      ),
      body: ListView.builder(
        itemCount: postList.length,
        itemBuilder: (context, index) {
          return Card(
              elevation: 50,
              shadowColor: Colors.black,
              color: Colors.blue[100],
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          SinglePostDio(id: postList[index].id)));
                },
                child: SizedBox(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          'User Id : ${postList[index].id}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Id : ${postList[index].userId}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          ' Body : ${postList[index].body}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          ' Title : ${postList[index].title}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ));
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


