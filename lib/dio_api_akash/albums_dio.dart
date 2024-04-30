import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apis/model/albums_model.dart';

class AlbumsDio extends StatefulWidget {
  int id;

  AlbumsDio({required this.id});

  @override
  State<AlbumsDio> createState() => _AlbumsDioState();
}

class _AlbumsDioState extends State<AlbumsDio> {
  late int id;
  List<AlbumModel> albumList=[];

  @override
  void initState() {
    super.initState();
    id=widget.id;
    getAlbumsApi(id);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Albums Api'),
      ),
      body: ListView.builder(itemCount: albumList.length,itemBuilder: (context,index){
        if(albumList.isNotEmpty){
          return Card(
            child: InkWell(
              onTap: (){

              },
              child: ListTile(
                title: Text(albumList[index].id.toString()),
                subtitle: Text(albumList[index].title),
              ),
            ),
          );
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }

  Future<void> getAlbumsApi(int id) async {
    final dio = Dio();
    try {
      final response = await dio.get(
        'https://jsonplaceholder.typicode.com/comments/$id/albums',
      );
      if (response.statusCode == 200) {
        print(response.data);
        setState(() {
          albumList = (response.data as List)
              .map((json) => AlbumModel.fromJson(json))
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
