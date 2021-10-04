import 'package:book_list_sample2/add_cd/add_cd_page.dart';
import 'package:book_list_sample2/book_list/book_list_model.dart';
import 'package:book_list_sample2/domain/cdtitle.dart';
import 'package:book_list_sample2/edit_cd/edit_cd_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatelessWidget {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('cdlist').snapshots();

  String pageTitle = 'CD一覧';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      create: (_) => BookListModel()..fetchBookList(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(pageTitle),
        ),
        body: Center(
          child: Consumer<BookListModel>(builder: (context, model, child) {
            final List<Cdtitle>? cdtitles = model.cdtitles;

            if (cdtitles == null) {
              return CircularProgressIndicator();
            }

            final List<Widget> widget = cdtitles
                .map(
                  (cdtitles) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6.0, vertical: 3.0),
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.20,
                      child: ListTile(
                        //tileColor: Colors.deepPurpleAccent,
                        leading: cdtitles.imageURL != null
                            ? Image.network(cdtitles.imageURL!)
                            : null,
                        //leading : cdtitles.imageURL != null ? Text(cdtitles.imageURL!) :null,
                        //leading : cdtitles.imageURL != null ? Image.network(cdtitles.imageURL!) :null,
                        title: Text(cdtitles.title),
                        subtitle: Text(cdtitles.author),
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: '編集',
                          color: Colors.black45,
                          icon: Icons.edit,
                          onTap: () async {
                            //編集画面に遷移
                            //画面遷移
                            final String title = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditCdListPage(cdtitles),
                              ),
                            );
                            if (title != null) {
                              final snackBar = SnackBar(
                                  backgroundColor: Colors.deepPurpleAccent,
                                  content: Text('$titleを編集しました'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                            model.fetchBookList();
                            //編集画面
                          },
                        ),
                        IconSlideAction(
                          caption: '削除',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () async {
                            await showConfirmDialog(context, cdtitles, model);
                            //削除
                          },
                        ),
                      ],
                    ),
                  ),
                )
                .toList();

            return ListView(
              children: widget,
            );
          }),
        ),
        floatingActionButton:
            Consumer<BookListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () async {
              //画面遷移
              final bool? added = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCdListPage(),
                  fullscreenDialog: true,
                ),
              );

              if (added != null && added) {
                const snackBar = SnackBar(
                    backgroundColor: Colors.green, content: Text('追加成功'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              model.fetchBookList();
            },
            child: const Icon(Icons.add),
          );
        }), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Future showConfirmDialog(
      BuildContext context, Cdtitle cdtitles, BookListModel model) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("削除の確認"),
          content: Text("${cdtitles.title}を削除しますか？"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
                child: Text("OK"),
                onPressed: () async {
                  await model.deleteCd(cdtitles);
                  Navigator.pop(context);
                  final snacBar = SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('『${cdtitles.title}』を削除しました'),
                  );
                  model.fetchBookList();
                  ScaffoldMessenger.of(context).showSnackBar(snacBar);
                }),
          ],
        );
      },
    );
  }
}
