class UtilsFormat {
  static String mask(String str, String mask) {
    String resultado = "";
    for (int i = 0;
        i < (mask.length < str.length ? mask.length : str.length);//pega o menor valor
        i++) {
      if (mask[i] == '#') {
        resultado += str[i];
      } else {
        resultado += mask[i];
      }
    }
    return resultado;
  }
}
