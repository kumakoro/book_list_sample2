import 'package:book_list_sample2/add_cd/add_cd_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCdListPage extends StatelessWidget {
  String pageTitle = 'CDを追加';
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('cdlist').snapshots();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddCdListModel>(
      create: (_) => AddCdListModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(pageTitle),
        ),
        body: Center(
          child: Consumer<AddCdListModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: model.imageFile != null
                              ? Image.file(model.imageFile!)
                              : Container(color: Colors.grey),
                        ),
                        onTap: () async {
                          await model.pickImage();
                        },
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'ここにCD名を入れてください',
                        ),
                        onChanged: (text) {
                          model.title = text;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'ここにタイトル名を入れてください',
                        ),
                        onChanged: (text) {
                          model.author = text;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            try {
                              model.statLoading();
                              await model.addCdListModel();
                              Navigator.of(context).pop(true);
                            } catch (e) {
                              print(e);
                              final snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(e.toString()),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } finally {
                              model.endLoading();
                            }
                          },
                          child: Text('追加する')),
                    ],
                  ),
                ),
                if (model.isLoding)
                  Container(
                    color: Colors.black45,
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
