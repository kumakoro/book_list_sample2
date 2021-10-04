import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddCdListModel extends ChangeNotifier {
  String? title;
  String? author;
  File? imageFile;
  String? imgURL;
  bool isLoding = false;
  final picker = ImagePicker();

  void statLoading(){
    isLoding = true;
    notifyListeners();
  }

  void endLoading(){
    isLoding = false;
    notifyListeners();
  }

  Future addCdListModel() async {
    if (title == null || title == "") {
      throw 'CDタイトルが入力されていません';
    }

    if (author == null || author!.isEmpty) {
      throw 'アーティスト名が入力されていません';
    }

    final doc = FirebaseFirestore.instance.collection('cdlist').doc();
    //先にストレージに登録する処理を実行

    String? imgURL;
    if (imageFile != null) {
      // storageにアップロード
      final task = await FirebaseStorage.instance
          .ref('cdlist/${doc.id}')
          .putFile(imageFile!);
      imgURL = await task.ref.getDownloadURL();
    }

    // firestoreに追加
    await doc.set({
      'title': title,
      'author': author,
      'imgURL': imgURL,
    });


    //FireStoreについか
    await FirebaseFirestore.instance.collection('cdlist').add({
      'title': title,
      'author': author,
      'imageURL': imgURL,
    });
  }

  Future pickImage() async {
    //final pickedFile = await pickImage(source: ImageSource.gallery);
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }
}
