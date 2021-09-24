import 'package:book_list_sample2/add_cd/add_cd_page.dart';
import 'package:book_list_sample2/book_list/book_list_model.dart';
import 'package:book_list_sample2/domain/cdtitle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatelessWidget {
  final Stream<QuerySnapshot> _usersStream =
  FirebaseFirestore.instance.collection('cdlist').snapshots();


  String label_1 = 'EMPiRE IS COMMING';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      create: (_) => BookListModel()..fetchBookList(),
      child : Scaffold(
        appBar: AppBar(
          title: Text('本一覧'),
        ),
        body: Center(
          child: Consumer<BookListModel>(builder: (context, model, child) {
            final List<Cdtitle>? cdtitles = model.cdtitles;

            if ( cdtitles == null ){
              return CircularProgressIndicator();
          }

            final List <Widget> widget = cdtitles.map(
              (cdtitles) => ListTile(
                title : Text(cdtitles.title),
                subtitle : Text(cdtitles.author),
              ),
            ).toList();
            return ListView(
              children : widget,
            );
          }),
        ),
        floatingActionButton: Consumer<BookListModel>(builder: (context, model, child) {
            return FloatingActionButton(
              onPressed: () async {
                //画面遷移
                final bool? added =
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddCdListPage(),
                      fullscreenDialog: true,
                  ),
                );

                if(added != null && added) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('追加成功')
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                }

                model.fetchBookList();
              },
              tooltip: 'Increment',
              child: Icon(Icons.add),
            );
          }
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
