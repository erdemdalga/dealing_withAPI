import 'dart:convert';
import 'dart:io';

import 'package:api_course/Models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PostsModel> postList = [];
  Future<List<PostsModel>> getPostApi() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    sleep(Duration(seconds: 20));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map<String, dynamic> i in data) postList.add(PostsModel.fromMap(i));
      return postList;
    } else {
      return postList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BottomAppBar(
      //   color: Color.fromARGB(255, 189, 234, 255),
      //   height: 75,
      //   elevation: 5,
      // ),
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Color.fromARGB(255, 189, 234, 255),
        toolbarHeight: 120,
        title: Text('REST APIs'),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Color.fromARGB(255, 189, 234, 255),
                color: Colors.red,
              ));
            else {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      subtitle: Text(postList[index].body.toString()),
                      title: Text(postList[index].title.toString()),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  );
                },
                itemCount: postList.length,
              );
            }
          },
          future: getPostApi(),
        ),
      ),
    );
  }
}
