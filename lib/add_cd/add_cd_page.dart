import 'package:book_list_sample2/add_cd/add_cd_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCdListPage extends StatelessWidget {

  String pageTitle = 'CDを追加';
  final Stream<QuerySnapshot> _usersStream =
  FirebaseFirestore.instance.collection('cdlist').snapshots();


  String label_1 = 'EMPiRE IS COMMING';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddCdListModel>(
      create: (_) => AddCdListModel(),
      child : Scaffold(
        appBar: AppBar(
          title: Text(pageTitle),
        ),
        body: Center(
          child: Consumer<AddCdListModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'ここにCD名を入れてください',
                    ),
                    onChanged: (text){
                      //ここで取得したテキストを使う
                      model.title = text;
                    },
                  ),
                  const SizedBox(height: 8,),
                  TextField(
                      decoration: const InputDecoration(
                        hintText: 'ここにタイトル名を入れてください',
                      ),
                    onChanged: (text){
                      //ここで取得したテキストを使う
                      model.author = text;
                    },
                  ),
                  const SizedBox(height: 8,),
                  ElevatedButton(
                      onPressed:() async {
                        try{
                          await model.addCdListModel();
                          Navigator.of(context).pop(true);

                        } catch(e) {
                          final snackBar = SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(e.toString()),);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        //追加の処理

                      },
                      child: Text('追加する')
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
