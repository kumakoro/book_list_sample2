import 'package:book_list_sample2/domain/cdtitle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditCdListModel extends ChangeNotifier {
  late final Cdtitle cdtitles;
  EditCdListModel(this.cdtitles) {
    titleController.text = cdtitles.title;
    authorController.text = cdtitles.author;
  }

  final titleController = TextEditingController();
  final authorController = TextEditingController();

  String? title;
  String? author;

  void setTitle (String title){
    this.title = title;
    notifyListeners();
  }

  void setAuthor (String author){
    this.title = author;
    notifyListeners();
  }


  bool isUpdated(){
    return title != null || author != null;
  }

  Future updateCdListModel() async {

    this.title = titleController.text;
    this.author = authorController.text;

    //FireStoreについか
    await FirebaseFirestore.instance.collection('cdlist').doc(cdtitles.id).update({
      'title' : title,
      'author': author,
    });

  }
}

