import "package:flutter/material.dart";
import "../widgets/TopBar.dart";

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: Center(child: Text("Mobile"))
    );
  }
}
