import 'package:flutter/material.dart';
import './picscannerpage.dart';

void main(){
  runApp( 
    MaterialApp(
      title: "Routes",
      routes: <String, WidgetBuilder> {
        '/': (context)=>_FirstPage(),
        '/pictureScanner': (context)=>PicScannerPage(),
      },
    )
  );
}

class _FirstPage extends StatefulWidget {
  @override
  __FirstPageState createState() => __FirstPageState();
}

class __FirstPageState extends State<_FirstPage> {
  String _widgetName = 'pictureScanner';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home page"),
      ),
      body: Center(

        child:
          Container( 
            width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(  
              color: Colors.teal,
              gradient: LinearGradient(  
                colors: [Colors.white, Colors.lime],
              )
            ),
            child: ListTile( 
              enabled: true,
              title: Text("Picture Scanner"),
              onTap: () => Navigator.pushNamed(context, '/$_widgetName'),
              subtitle: Text("Go on and select your Image to be processed"),
            ),
          )
      ),
    );
  }
}