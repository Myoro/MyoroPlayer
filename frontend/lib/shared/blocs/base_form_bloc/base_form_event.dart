import 'package:flutter/material.dart';

@immutable
final class BaseFormEvent {
  const BaseFormEvent();
}

final class FinishFormEvent extends BaseFormEvent {
  const FinishFormEvent();
}
