import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../State.dart" as StateManagement;

class TopBarButton extends StatelessWidget {
  final String lightImage;
  final String darkImage;

  TopBarButton({ required this.lightImage, required this.darkImage });

  @override
  Widget build(BuildContext context) {
    final StateManagement.State state = Provider.of<StateManagement.State>(context);

    return Container(
      width:  40,
      height: 40,
      child:  Image.asset(!state.state.darkMode ? lightImage : darkImage)
    );
  }
}
