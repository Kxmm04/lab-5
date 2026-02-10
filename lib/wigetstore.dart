import 'package:flutter/material.dart';

Widget inputText(String hintText){
  return TextField(
    controller: null,
    decoration: InputDecoration(
      hintText: "ข้อความลอย",
      prefixIcon: Icon(Icons.search),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      )
    ),

  );
}