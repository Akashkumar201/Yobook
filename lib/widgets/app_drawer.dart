import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Screens/order_screen.dart';
import '../Screens/user_product_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(child: Column(children: <Widget>[
 UserAccountsDrawerHeader(
                  
                  accountName: Text("आकाश कुमार💖", style: TextStyle(color: Colors.green)),
                  accountEmail: Text("+91-8521501702", style: TextStyle(color: Colors.green)),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/Capture.PNG'),
                  ),
                  decoration: BoxDecoration(color: Colors.white),
                ),      Divider(),
      ListTile(leading:Icon(Icons.shop,color: Colors.yellowAccent,),
      title: Text('दुकान'),
      onTap: (){
        Navigator.of(context).pushReplacementNamed('/');

      },),
      Divider(),
      ListTile(leading:Icon(Icons.payment,color: Colors.lightBlueAccent, ),
      
      title: Text('ऑडर'),
      onTap: (){
        Navigator.of(context).pushReplacementNamed(OrdersScreen.routName);

      },),
      Divider(),
      ListTile(leading:Icon(Icons.edit,color: Colors.greenAccent,),
      title: Text('उत्पाद प्रबंधित करें'),
      onTap: (){
        Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);

      },),
      Divider(),
      ListTile(leading:Icon(Icons.airport_shuttle,color: Colors.pinkAccent,),
      title: Text('परिवहन सेवाएं'),
      onTap: (){
        Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);

      },),
      Divider(),
      ListTile(leading:Icon(Icons.storage,color: Colors.black,),
      title: Text('श्रम डेटाबेस'),
      onTap: (){
        Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);

      },),
      Divider(),
      ListTile(leading:Icon(Icons.exit_to_app,color: Colors.blue[400],),
      title: Text('LogOut'),
      onTap: (){
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed('/');
       
       Provider.of<Auth>(context,listen: false).logout();

      },),
    ],),);
  }
}