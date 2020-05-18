class FormatNumber {
  static double toDoubleOr(String str, double padrao) {
    return double.tryParse(str) ?? padrao;
  }

  static int toIntOr(String str, int padrao) {
    return int.tryParse(str) ?? padrao;
  }
}
