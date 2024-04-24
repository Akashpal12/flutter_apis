import 'package:flutter/material.dart';
import 'package:flutter_apis/dio_api/post_dio.dart';
import 'package:flutter_apis/https_api/post_https.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter ApiCall",
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Api Call"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PostDioApi()));
                },
                child: Text(
                  "Dio Api Call",
                )),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PostHttpApi()));
            }, child: Text("Http Api Call")),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
