// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'package:news_app/category.dart';
import 'package:news_app/model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart';

import 'model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

// ignore: non_constant_identifier_names
Category({required Query}) {
  //error handling next day will start from here......
}

class _HomeState extends State<Home> {
  TextEditingController searchController = new TextEditingController();
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  //List<NewsQueryModel> newsModelListCarousel = <NewsQueryModel>[];

  List<String> navBarItem = [
    "Top News",
    "India",
    "World",
    "Finacnce",
    "Health"
  ];

  bool isLoading = true;

  //var query;
  getNewsByQuery(String query) async {
    String url =
        //"https://newsapi.org/v2/top-headlines?country=in&apiKey=9bb7bf6152d147ad8ba14cd0e7452f2f";

        "https://newsapi.org/v2/everything?q=$query&from=2022-09-25&sortBy=publishedAt&apiKey=85883bef24e54fc88079992a15110410";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelList.add(newsQueryModel);

        setState(() {
          isLoading = false;
        });
      });
    });
  }

  // getNewsByProvider(String provider) async {
  //   String url =
  //       //"https://newsapi.org/v2/top-headlines?country=in&apiKey=9bb7bf6152d147ad8ba14cd0e7452f2f";

  //       "https://newsapi.org/v2/everything?q=$query&from=2022-09-25&sortBy=publishedAt&apiKey=85883bef24e54fc88079992a15110410";
  //   Response response = await get(Uri.parse(url));
  //   Map data = jsonDecode(response.body);
  //   setState(() {
  //     data["articles"].forEach((element) {
  //       NewsQueryModel newsQueryModel = new NewsQueryModel();
  //       newsQueryModel = NewsQueryModel.fromMap(element);
  //       newsModelList.add(newsQueryModel);

  //       setState(() {
  //         isLoading = false;
  //       });
  //     });
  //   });
  // }

  getNewsofIndia() async {
    String url =
        //"https://newsapi.org/v2/top-headlines?country=in&apiKey=9bb7bf6152d147ad8ba14cd0e7452f2f";

        "https://newsapi.org/v2/top-headlines?country=in&apiKey=85883bef24e54fc88079992a15110410";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelList.add(newsQueryModel);

        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery("india");
    getNewsofIndia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NEWS APP"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              //Search Container

              padding: EdgeInsets.symmetric(horizontal: 8),
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if ((searchController.text).replaceAll(" ", "") == "") {
                        print("Blank search");
                      } else {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => Search(searchController.text)));
                      }
                    },
                    child: Container(
                      child: Icon(
                        Icons.search,
                        color: Colors.blueAccent,
                      ),
                      margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        print(value);
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Search here"),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 50,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: navBarItem.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      // print(navBarItem[index]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Category(Query: navBarItem[index]),
                        ),
                      );

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         Category(Query:navBarItem[index])
                      //   ),
                      // );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(navBarItem[index],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  );
                },
              ),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: CarouselSlider(
                //to scroll news contains.
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 2),
                  enlargeCenterPage: true,
                ),

                items: newsModelList.map((instance) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        //margin: EdgeInsets.symmetric(vertical: 15),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  instance.newsImg,
                                  fit: BoxFit.fitHeight,
                                  height: double.infinity,
                                ),
                              ),
                              Positioned(
                                left: 4,
                                right: 0,
                                bottom: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black12.withOpacity(0),
                                          Colors.black,
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      )),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 10),
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        instance.newsHead,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );

                      // InkWell(
                      //   onTap: () {
                      //     print("Hello Geeks Happy Diwali !");
                      //   },
                      //   child: Container(
                      //     margin:
                      //         EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                      //     // decoration:BoxDecoration(
                      //     // color: item),
                      //     child: Text(item),
                      //   ),
                      // );
                    },
                  );
                }).toList(),
                // options: options)
              ),
            ),
            Container(
              //foe bottom images..

              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 25, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          " LATEST NEWS",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,

                      //itemCount:4,
                      itemCount: newsModelList.length,
                      itemBuilder: (context, index) {
                        //Image.asset("images/news00.jpg"),
                        return Container(
                          // child: Text("Akash"),
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),

                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 35.0,
                            child: Stack(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    // child: Image.asset("images/news00.jpg")),
                                    child: Image.network(
                                      newsModelList[index].newsImg,
                                      fit: BoxFit.fitHeight,
                                      height: 190,
                                      width: double.infinity,
                                    )),
                                Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black12.withOpacity(0),
                                              Colors.black
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          )),
                                      padding:
                                          EdgeInsets.fromLTRB(10, 15, 10, 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            //" NEWS HEADLINES",
                                            newsModelList[index].newsHead,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              newsModelList[index]
                                                          .newsDes
                                                          .length >
                                                      50
                                                  ? "${newsModelList[index].newsDes.substring(0, 55)}..."
                                                  : newsModelList[index]
                                                      .newsDes,
                                              // Text(
                                              //     "Are you allowed to burst firecrackers in your state",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                              )),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        );
                      }),
                  //## BUTTON (SHOE MORE) !!! here
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Show More"),
                        )
                      ],
                    ),
                  )
                  //## BUTTON (SHOE MORE) !!! here
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //final List items = [Colors.blueAccent,Colors.red,Colors.yellow];
  final List items = ["physisc", "KIET", "Eng", "coder", "CP", "Festival"];
}


//TIME TO CALL API 
// 40% COMPLETED......
//WELL DONE