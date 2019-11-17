import 'dart:io';

class UtilsDownload {
  static Future<File> baixarArquivo(String fonte, String nome) async {
    HttpClient client = new HttpClient();
    HttpClientRequest request = await client.getUrl(Uri.parse(fonte));
    HttpClientResponse response = await request.close();
    if (response.statusCode < 400) {
      File file = File('./$nome');
      file = await file.create();
      response.pipe(file.openWrite());
      return file;
    }
  }
}
