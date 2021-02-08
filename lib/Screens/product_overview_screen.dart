import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/product_grid.dart';
import '../providers/products.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../widgets/coresul.dart';


enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
 
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fatchAndSetProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      // backgroundColor:Colors.indigo[100],
      appBar: AppBar(
        title: Text("Yobook"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                  
                  } else {
                  _showOnlyFavorites = false;
                  //  productsContainer.showAll();
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Discount"),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text("Nearby"),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.add_shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
    
      body:  _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
          
            child: Column(
              
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
               Cerosul(),
               

               
               ProductsGrid(_showOnlyFavorites)
            ],)
          )
    );
    
    
  }
}

