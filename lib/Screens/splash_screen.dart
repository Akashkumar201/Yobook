import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.purpleAccent[100],
//       body: Center(
//         child: Text(
//           "Welcome To The Indea biggest Book Store",
//           style: TextStyle(
//             fontSize: 50.0,
//             color: Colors.white,
//             fontFamily: "Dosis",
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }
 return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              Padding(padding: EdgeInsets.only(bottom: 30.0),child:new Image.asset('assets/images/powered_by.png',height: 25.0,fit: BoxFit.scaleDown,))


          ],),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/images/logo.png',
               
              ),
            ],
          ),
        ],
      ),
    );
  }
}