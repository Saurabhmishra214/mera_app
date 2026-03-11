import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class taskStorage {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late File file;
  var task = ImagePicker();

  Future<String> uploadTask() async {
    // FIX: getImage() deprecated → use pickImage()
    var filePicked = await task.pickImage(source: ImageSource.gallery);
    if (filePicked != null) {
      file = File(filePicked.path);
      var imageName = basename(filePicked.path);
      print(imageName);

      var refStorage =
          _storage.ref("task/$imageName").child(_auth.currentUser!.uid);
      await refStorage.putFile(file);
      String Url = await refStorage.getDownloadURL();
      print("Url=============: $Url");
      return Url;
    } else {
      return "NO_FILE_SELECTED";
    }
  }
}