import 'dart:convert';

import 'package:api_course/Models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePageThree extends StatefulWidget {
  const HomePageThree({super.key});

  @override
  State<HomePageThree> createState() => _HomePageThreeState();
}

class _HomePageThreeState extends State<HomePageThree> {
  List<UserModel> userList = [];
  Future<List<UserModel>> getUserApi() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    final data = jsonDecode(response.body.toString());

    if (response.statusCode == 200 && userList.isEmpty) {
      for (Map<String, dynamic> i in data) {
        userList.add(UserModel.fromMap(i));
      }
      print(userList.length);
      return userList;
    } else
      return userList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Color.fromARGB(255, 255, 224, 185),
        toolbarHeight: 120,
        title: Text(
          'REST API DAY3',
          style: TextStyle(fontWeight: FontWeight.w100),
        ),
        centerTitle: true,
      ),
      body: mainBody(),
    );
  }

  FutureBuilder<List<UserModel>> mainBody() => FutureBuilder(
      future: getUserApi(),
      builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Color.fromARGB(255, 249, 214, 172),
              color: Colors.lightBlue,
            ),
          );
        else if (snapshot.hasError)
          return Center(
            child: Text('Unable to fetch data at the moment'),
          );
        else
          return ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  margin: EdgeInsets.only(
                      left: 10, right: 10, top: 1.5, bottom: 10),
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 252, 241, 204),
                          Color.fromARGB(255, 255, 215, 180)
                        ])),
                    padding: EdgeInsets.all(8),
                    height: 200,
                    child: Row(
                      children: [
                        Expanded(child: column2(snapshot, index)),
                        Expanded(child: column1(snapshot, index)),
                      ],
                    ),
                  ));
            },
            itemCount: userList.length,
          );
      });

  Column column2(AsyncSnapshot<List<UserModel>> snapshot, int index) {
    TextStyle stl = TextStyle(fontSize: 8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Center(
                child: Text(
              '${index + 1}',
              style: stl,
            )),
            radius: 12,
          ),
        ),
        Expanded(
          child: Text(
            'Id: ' + snapshot.data![index].id.toString(),
            style: stl,
          ),
        ),
        Expanded(
          child: Text(
            'Name: ' + snapshot.data![index].name,
            style: stl,
          ),
        ),
        Expanded(
          child: Text(
            'Username: ' + snapshot.data![index].username,
            style: stl,
          ),
        ),
        Expanded(
          child: Text(
            'Email: ' + snapshot.data![index].email,
            style: stl,
          ),
        ),
        Expanded(
          child: Text(
            'Website: ' + snapshot.data![index].website,
            style: stl,
          ),
        ),
      ],
    );
  }

  Column column1(AsyncSnapshot<List<UserModel>> snapshot, int index) {
    TextStyle stl = TextStyle(fontSize: 8);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Phone: ' + snapshot.data![index].phone,
          style: stl,
        ),
        Text(
          'Address: ' +
              snapshot.data![index].address.street +
              ',\n' +
              snapshot.data![index].address.city +
              ',\n' +
              snapshot.data![index].address.zipcode,
          style: stl,
        ),
        Text(
          'Company: ' +
              snapshot.data![index].company.name +
              '\nBS: ' +
              snapshot.data![index].company.bs,
          style: stl,
        )
      ],
    );
  }
}
