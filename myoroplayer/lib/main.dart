import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "./State.dart" as StateManagement;
import "./Themes.dart";
import "./screens/MainScreen.dart";

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
    final StateManagement.State state = Provider.of<StateManagement.State>(context);

    return MaterialApp(
      title: "MyoroPlayer",
      theme: !state.state.darkMode ? light : dark,
      home:  MainScreen()
    );
  }
}
