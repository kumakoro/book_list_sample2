import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:book_list_sample2/domain/cdtitle.dart';

class BookListModel extends ChangeNotifier {
  // _を先頭につけるとプライベートになるからこのクラス内でしか呼び出せなくなる。
  // 特に呼ぶ必要がないものは_をつけたほうがいい
  final _userCollection = FirebaseFirestore.instance.collection('cdlist');

  List<Cdtitle>? cdtitles = [];

  void fetchBookList() async {

    final QuerySnapshot snapshot = await _userCollection.get();
    final List<Cdtitle> cdtitles = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String id = document.id;
      final String title = data['title'];
      final String author = data['author'];
      final String? imageURL = data['imageURL'];
      return Cdtitle(id,title, author,imageURL);
    }).toList();

    this.cdtitles = cdtitles;
    notifyListeners();
  }

  Future deleteCd(Cdtitle cdtitles){
    return FirebaseFirestore.instance.collection('cdlist').doc(cdtitles.id).delete();
  }
}

