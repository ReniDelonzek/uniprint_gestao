import 'dart:io';

class UtilsDownload {
  static Future<File> baixarArquivo(
      String fonte, String diretorio, String nome) async {
    HttpClient client = new HttpClient();
    HttpClientRequest request = await client.getUrl(Uri.parse(fonte));
    HttpClientResponse response = await request.close();
    if (response.statusCode < 400) {
      var dir = Directory('./$diretorio');
      if ((await dir.exists()) == false) {
        dir = await dir.create();
      }
      File file = File('${dir.path}/$nome');
      if ((await file.exists()) == false) {
        file = await file.create();
      }
      await response.pipe(file.openWrite());
      return file;
    }
    return null;
  }
}
