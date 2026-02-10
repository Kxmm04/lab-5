import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'wigetstore.dart';

class productlistPage extends StatefulWidget {
  const productlistPage({super.key});

  @override
  State<productlistPage> createState() => _productlistPageState();
}

class _productlistPageState extends State<productlistPage> {
  List<dynamic> data = [];

  @override
  @override
  void initState() {
    super.initState();
    getProductList();
  }

  Future<String> getProductList() async {
    Map<String, String> headers = {
      "content-type": "application/json",
      "accept": "application/json",
    };
    Map<String, String> dataPost = {"search_pro_name": ""};

    var uri = Uri.parse(
      "http://172.24.148.197/bis3n2_2/mobile_service_68/get_product_list.php",
    );

    var response = await http.post(
      uri,
      headers: headers,
      body: json.encode(dataPost),
      encoding: Encoding.getByName("utf-8"),
    );

    Map respJson = json.decode(response.body);
    // print(respJson);

    setState(() {
      data = respJson['datalist'];
    });
    print(data);

    return "OK";
  }

  Widget CardList(
    String pro_id,
    String pro_name,
    String pro_price,
    String pro_image,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      height: MediaQuery.of(context).size.height * 0.3,
      child: Card(
        color: Colors.blue.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 8,
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: Image.network(pro_image),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text("รหัสสินค้า: $pro_id"),
                  const SizedBox(height: 6),
                  Text(
                    "ชื่อสินค้า: $pro_name",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 6),
                  Text("ราคา: $pro_price บาท"),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      print("Received Click");
                    },
                    child: const Text("สั่งซื้อ"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> displayProductList() {
    return data.map((product) {
      return CardList(
        product["pro_id"].toString(),
        product["pro_name"].toString(),
        product["pro_price"].toString(),
        product["pro_image"].toString(),
      );
    }).toList();
  }


Widget layoutSearch(){
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
       Expanded(child: inputText("ค้นหาสินค้า")),
        Text("buttonSearch"),
      ],
    ),
  );
}


  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("แอพบาร์จ้า"),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(
          child: ListView(
            children: 
            [
              layoutSearch(),
              ...displayProductList(),
              ],
            ),
          ),
      ),
    );
  }
}
