import 'package:flutter/material.dart';

@immutable
abstract class MainScreenBodyPlaylistSideBarEvent {
  const MainScreenBodyPlaylistSideBarEvent();
}

final class CreatePlaylistEvent extends MainScreenBodyPlaylistSideBarEvent {
  const CreatePlaylistEvent();
}
