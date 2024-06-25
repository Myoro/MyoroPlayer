enum SnackBarTypeEnum {
  dialog,
  error;

  bool get isTypeError => this == SnackBarTypeEnum.error;
}
