import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:book_list_sample2/domain/cdtitle.dart';

class BookListModel extends ChangeNotifier {
  final Stream<QuerySnapshot> _usersStream =
  FirebaseFirestore.instance.collection('cdlist').snapshots();

  List<Cdtitle>? cdtitles = [];

  void fetchBookList() {
    _usersStream.listen((QuerySnapshot snapshot) {
      final List<Cdtitle> cdtitles = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        final String title = data['title'];
        final String author = data['author'];
        return Cdtitle(title, author);
      }).toList();
    this.cdtitles = cdtitles;
    notifyListeners();
        });
  }
}

