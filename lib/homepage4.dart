//Here we will fetch and api which has data in the object form not in the form array

import 'dart:convert';

import 'package:api_course/Models/ProductModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePageFour extends StatefulWidget {
  const HomePageFour({super.key});

  @override
  State<HomePageFour> createState() => _HomePageFourState();
}

class _HomePageFourState extends State<HomePageFour> {
  Future<ProductModel> getProductsApi() async {
    final response = await http.get(
        Uri.parse('https://webhook.site/9f8dc367-aa21-4c5f-bd5a-3eddfd1acb93'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200)
      return ProductModel.fromMap(data);
    else
      return ProductModel.fromMap(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 140,
        elevation: 5,
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
        title: Text(
          'REST API -dealing with complex json',
          style: TextStyle(fontWeight: FontWeight.w200, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder<ProductModel>(
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.lightGreen,
                      backgroundColor: Colors.blue.shade100,
                    ),
                  );
                else if (snapshot.hasError)
                  return Center(
                    child: Text('OOPs couldn\'t fetch data'),
                  );
                else
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  snapshot.data!.data[index].shop.image),
                            ),
                            title: Text(
                                snapshot.data!.data[index].shop.shopaddress),
                            subtitle:
                                Text(snapshot.data!.data[index].shop.shopemail),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * .3,
                            width: MediaQuery.of(context).size.width * 1,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, position) {
                                return Container(
                                  margin: EdgeInsets.all(5),
                                  height:
                                      MediaQuery.of(context).size.height * .25,
                                  width: MediaQuery.of(context).size.width * .5,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            snapshot.data!.data[index]
                                                .images[position].url
                                                .toString(),
                                          ))),
                                );
                              },
                              itemCount:
                                  snapshot.data!.data[index].images.length,
                            ),
                          ),
                          Icon(snapshot.data!.data[index].inWishlist == false
                              ? Icons.favorite
                              : Icons.favorite_outline)
                        ],
                      );
                    },
                    itemCount: snapshot.data!.data.length,
                  );
              },
              future: getProductsApi(),
            ))
          ],
        ),
      ),
    );
  }
}
