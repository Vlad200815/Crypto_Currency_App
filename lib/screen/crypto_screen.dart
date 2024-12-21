import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giga/screen/home_screen.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

class CryptoScreen extends StatefulWidget {
  const CryptoScreen({super.key});

  @override
  State<CryptoScreen> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<List<dynamic>> _fetchData() async {
    final url = Uri.parse(
        "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Failed to connect to the api");
    }
  }

  Future<void> _loadData() async {
    List<dynamic> test = await _fetchData();
    setState(() {
      data = test;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     print("---------------------$data");
      //   },
      //   child: Icon(Icons.add),
      // ),
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          },
          icon: Icon(
            CupertinoIcons.chevron_back,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Crypto Currency",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final String name = data[index]['name'];
          final String image = data[index]["image"];
          final num price = data[index]['current_price'];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: NetworkImage(image),
                    height: 60,
                  ),
                  SizedBox(width: 170),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      name.length > 14
                          ? Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 5,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      Text(
                        "${price.toString()}\$",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
