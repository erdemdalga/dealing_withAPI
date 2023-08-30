import 'dart:convert';
import 'dart:io';

import 'package:api_course/Models/model2.dart';
import 'package:api_course/Models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Photos> photosList = [];
  List<PostsModel> postList = [];
  Future<List<Photos>> getPostApi() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map m in data) {
        Photos photos = Photos(id: m['id'], title: m['title'], url: m['url']);
        photosList.add(photos);
      }
      return photosList;
    } else
      return photosList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Color.fromARGB(255, 189, 234, 255),
        toolbarHeight: 120,
        title: Text('REST APIs'),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
            future: getPostApi(),
            builder: (context, AsyncSnapshot<List<Photos>> snapshot) {
              if (!snapshot.hasData)
                return Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.red,
                  color: Color.fromARGB(255, 189, 234, 255),
                ));
              else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      height: 100,
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(snapshot.data![index].id.toString()),
                        ),
                        title: Text(snapshot.data![index].title),
                        trailing: Container(
                          width: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.network(snapshot.data![index].url),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: 10,
                );
              }
            }),
      ),
    );
  }

  Container post_modelBody() {
    return Container(
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
    );
  }
}
