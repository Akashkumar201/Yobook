import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import '../Pdfview/model.dart';
// import '../widgets/customappbar.dart';
import '../Pdfview/Viewpdf.dart';

class ProductDetailScreen extends StatefulWidget {
  // final String title;
  // final double price;
  // ProductDetailScreen(this.title,this.price);
  static const routeName = '/product-detail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
   List<Model> itemList = List();

  final firebasereference =
      FirebaseDatabase.instance.reference().child("Database");
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);

    return Scaffold(
    
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title,style: TextStyle(color: Colors.blue[900],fontFamily: 'Dosis',fontWeight: FontWeight.bold),),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 10,
                ),
                Text(
                  '\₹${loadedProduct.price}',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                  ),
                  textAlign:TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.blue[900]
                    ),
                  ),
                ),
                
                SizedBox(
                  height: 800,
                ),
              ],
            ),
          ),
        
        ],
      ),
      
      
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
