import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCdListModel extends ChangeNotifier {
  String? title;
  String? author;

 Future addCdListModel() async {

   if ( title == null || title == "" ) {
     throw 'CDタイトルが入力されていません';
   }

   if ( author == null || author!.isEmpty) {
     throw 'アーティスト名が入力されていません';
   }

   //FireStoreについか
   await FirebaseFirestore.instance.collection('cdlist').add({
     'title' : title,
     'author': author,
   });

 }
}

