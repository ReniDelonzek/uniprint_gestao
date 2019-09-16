import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UtilsFirebaseFile {
  Future<String> putFile(File file, String patch) async {
    StorageUploadTask uploadTask =
        FirebaseStorage.instance.ref().child(patch).putFile(file);
    var a = await uploadTask.onComplete;
    return a.ref.getDownloadURL();
    /*uploadTask.onComplete.then((onValue) {
       onValue.ref.getDownloadURL().then((url) {
         
       }); 
    }).catchError((error) {
      
    });*/
  }

  File getDownloadFile() {

  }
}
