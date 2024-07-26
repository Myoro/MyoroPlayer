enum SnackBarTypeEnum {
  dialog,
  error;

  bool get isTypeError => this == SnackBarTypeEnum.error;

  bool get isDialog => this == dialog;
  bool get isError => this == error;
}
