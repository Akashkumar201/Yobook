import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import './model.dart';
import '../widgets/customappbar.dart';
import './Viewpdf.dart';

class PdfView extends StatefulWidget {
  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  List<Model> itemList = List();

  final firebasereference =
      FirebaseDatabase.instance.reference().child("Database");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("YoBook"),
        backgroundColor: Colors.blue,
        shape: CustomShapeBorder(),
        leading: Icon(Icons.menu),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          )
        ],
      ),
      body: itemList.length == 0
          ? Center(
              child: SpinKitCubeGrid(size: 51.0, color: Colors.redAccent),
            )
          : ListView.builder(
              padding: EdgeInsets.only(top: 40),
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: GestureDetector(
                    onTap: () {
                      String passData = itemList[index].link;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewPdf(),
                          settings: RouteSettings(
                            arguments: passData,
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/books.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            height: 140,
                            child: Card(
                              margin: EdgeInsets.all(1),
                              elevation: 7.0,
                              child: Center(
                                child: Text(itemList[index].name +
                                    " " +
                                    (index + 1).toString()),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getPdfAndUpload();
        },
        child: Icon(Icons.add, color: Colors.lightBlueAccent),
      ),
    );
  }

  Future getPdfAndUpload() async {
    var rng = new Random();
    String randomName = "";
    for (var i = 0; i < 10; i++) {
      randomName += rng.nextInt(100).toString();
    }
    File file = await FilePicker.getFile(type: FileType.custom);
    String fileName = '${randomName}.pdf';
    savePdf(file.readAsBytesSync(), fileName);
  }

  savePdf(List<int> asset, String name) async {
    StorageReference reference = FirebaseStorage.instance.ref().child(name);
    StorageUploadTask uploadTask = reference.putData(asset);
    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    documentFileUpload(url);
  }

  String RandomCriptoString([int length = 32]) {
    final Random _random = Random.secure();
    var values = List<int>.generate(length, (index) => _random.nextInt(256));
    return base64Url.encode(values);
  }

  void documentFileUpload(String str) {
    var data = {
      "PDF": str,
      "FileName": "New Notes Of Machine Learning",
    };
    firebasereference.child(RandomCriptoString()).set(data).then((value) {
      print("Kam Ho Gya");
    });
  }

  @override
  void initState() {
    firebasereference.once().then((DataSnapshot snap) {
      var data = snap.value;
      itemList.clear();
      data.forEach((key, value) {
        Model m = new Model(value['PDF'], value['FileName']);
        itemList.add(m);
      });
      setState(() {
        print("Value is ");
        print(itemList.length);
      });
    });
  }
}
