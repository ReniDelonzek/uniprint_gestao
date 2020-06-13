import 'dart:io';

class UtilsDownload {
  static Future<File> baixarArquivo(
      String fonte, String diretorio, String nome) async {
    File file = File('$diretorio/$nome');
    if ((await file.exists()) == false) {
      // caso o arquivo ainda não exista
      HttpClient client = new HttpClient();
      HttpClientRequest request = await client.getUrl(Uri.parse(fonte));
      HttpClientResponse response = await request.close();
      if (response.statusCode < 400) {
        Directory dir = Directory('$diretorio');
        if ((await dir.exists()) == false) {
          dir = await dir.create(recursive: true);
        }
        file = File('${dir.path}/$nome');
        if ((await file.exists()) == false) {
          file = await file.create(recursive: true);
        }
        await response.pipe(file.openWrite());
        return file;
      }
    } else {
      return file;
    }
    return null;
  }
}
