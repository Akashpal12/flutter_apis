import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apis/firebase/real_time_db/real_time_database.dart';
import 'dio_api_akash/post_dio1.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
                 Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PostDioNewApi()));
                },
                child: Text(
                  "Dio Api Call",
                )),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      //MaterialPageRoute(builder: (context) => PostHttpApi()));
                      //MaterialPageRoute(builder: (context) => CameraScreen()));
                      MaterialPageRoute(builder: (context) => RealTimeDB()));
                },
                child: Text("Http Api Call")),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
