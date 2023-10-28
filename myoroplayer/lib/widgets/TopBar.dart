import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../State.dart" as StateManagement;
import "./TopBarButton.dart";

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme             = Theme.of(context);
    final StateManagement.State state = Provider.of<StateManagement.State>(context);

    List<Map<String, String>> mainScreenMenuItems = [
      { "value": "setDarkMode", "text": "Enable " + (state.state.darkMode ? "Light" : "Dark") + " Mode" },
      { "value": "newPlaylist", "text": "Create Playlist" },
      { "value": "openPlaylist", "text": "Open Existing Playlist" },
      { "value": "settings", "text": "Settings" },
    ];

    List<PopupMenuEntry<dynamic>> itemBuilder() {
      return mainScreenMenuItems.map((item) {
        return PopupMenuItem(
          value: item["value"],
          child: Center(child: Text(item["text"]!, style: theme.textTheme.bodyMedium))
        );
      }).toList();
    }

    void onSelected(String choice) {
      switch(choice) {
        case "setDarkMode": state.setDarkMode(); break;
        default:                                 break;
      }
    }

    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TopBarButton(lightImage: "assets/img/LogoLight.png", darkImage: "assets/img/LogoDark.png"),
          PopupMenuButton(
            icon:        TopBarButton(lightImage: "assets/img/DropdownLight.png", darkImage: "assets/img/DropdownDark.png"),
            itemBuilder: (BuildContext context) => itemBuilder(),
            onSelected:  (dynamic choice) => onSelected(choice),
            offset:      Offset(-10, 70),
            shape:       RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
          )
        ]
      )
    );
  }
}
