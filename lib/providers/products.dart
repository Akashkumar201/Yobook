import 'dart:convert';
import 'dart:wasm';
import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import 'package:http/http.dart' as http;
import './product.dart';
class Products with ChangeNotifier{
   List<Product> _items=[

   ];
   final String authToken;
   final String userId;
   Products(this.authToken,this.userId,this._items);
   List<Product> get items{
     return [..._items];
   }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
  Future<void> fatchAndSetProduct([bool filterByUser=false]) async {
    final filterString=filterByUser ? 'orderBy="creatorId"&equalTo="$userId"':'';
    var url = 'https://yobook-3bf71.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData==null){
        return;
      }
      url='https://yobook-3bf71.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData=json.decode(favoriteResponse.body);
      final List<Product> loadProducts =[];
      extractedData.forEach((prodId, prodData) {
        loadProducts.add(Product(id: prodId,
        title: prodData['title'],
        description: prodData['description'],
        price: prodData['price'],
        isFavorite: favoriteData==null ? false : favoriteData[prodId]??false,
         imageUrl: prodData['imageUrl'],
         ));
       });
       _items=loadProducts;
       notifyListeners();
    }catch(error){
      throw(error);
    }

  }
  Future<void> addProduct(Product product) async{
    final url = 'https://yobook-3bf71.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(url,
      body:json.encode({
        'title':product.title,
        'description':product.description,
        'imageUrl':product.imageUrl,
        'price':product.price,
        'creatorId':userId,

      }),
      );
      final newProduct = Product(title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();

    }catch(error){
      print(error);
      throw error;
    }
  }
  Future<void> updateProduct(String id, Product newProduct) async{
    final prodIndex = _items.indexWhere((prod) => prod.id==id);
    if(prodIndex>=0){
      final url = 'https://yobook-3bf71.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
      body: json.encode({
        'title':newProduct.title,
        'description':newProduct.description,
        'imageUrl':newProduct.imageUrl,
        'price':newProduct.price,
      }));
      _items[prodIndex]==newProduct;
      notifyListeners();


    } else {
      print('...');
    }
  }
  Future<void> deleteProduct(String id) async{
    final url = 'https://shopapp-a7151.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod==id);
    var exsitingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response =await http.delete(url);
    if(response.statusCode >=200){
      _items.insert(existingProductIndex, exsitingProduct);
      notifyListeners();
      throw HttpException("Couldn't Delete Product !");
    }
        
  }

   }
