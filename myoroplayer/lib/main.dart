import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "./State.dart" as StateManagement;
import "./Themes.dart";
import "./desktop/screens/MainScreen.dart" as Desktop;
import "./mobile/screens/MainScreen.dart" as Mobile;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => StateManagement.State(),
      child:  App()
    )
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MyoroPlayer",
      theme: light,
      home:  MediaQuery.of(context).size.width > 600 ? Desktop.MainScreen() : Mobile.MainScreen()
    );
  }
}
