import 'package:book_list_sample2/add_cd/add_cd_model.dart';
import 'package:book_list_sample2/domain/cdtitle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_list_sample2/edit_cd/edit_cd_model.dart';


class EditCdListPage extends StatelessWidget {
  late final Cdtitle cdtitles;
  EditCdListPage(this.cdtitles);

  String pageTitle = 'CDを編集';
  final Stream<QuerySnapshot> _usersStream =
  FirebaseFirestore.instance.collection('cdlist').snapshots();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditCdListModel>(
      create: (_) => EditCdListModel(cdtitles),
      child : Scaffold(
        appBar: AppBar(
          title: Text(pageTitle),
        ),
        body: Center(
          child: Consumer<EditCdListModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller : model.titleController,
                    decoration: const InputDecoration(
                      hintText: 'ここにCD名を入れてください',
                    ),
                    onChanged: (text){
                      //ここで取得したテキストを使う
                      //model.title = text;
                      model.setTitle(text);
                    },
                  ),
                  const SizedBox(height: 8,),

                  TextField(
                    controller : model.authorController,
                    decoration: const InputDecoration(
                      hintText: 'ここにタイトル名を入れてください',
                    ),
                    onChanged: (text){
                      //ここで取得したテキストを使う
                      //model.author = text;
                      model.setAuthor(text);
                    },
                  ),
                  const SizedBox(height: 8,),

                  ElevatedButton(
                      onPressed: model.isUpdated() ? () async {
                        try {
                          await model.updateCdListModel();
                          Navigator.of(context).pop(model.title);
                        }
                        catch(e) {
                          final snackBar = SnackBar(backgroundColor: Colors.red,content: Text(e.toString()),);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      } : null,
                      child: Text('更新する')
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
