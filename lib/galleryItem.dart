import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class GalleryItem {
  GalleryItem({required this.id, required this.resource, this.isSvg = false});

  final String id;
  String resource;
  final bool isSvg;
}

class GenerateImageUrl {
  late bool success;
  late String message;

  late bool isGenerated;
  late String uploadUrl;
  late String downloadUrl;

  Future<void> call(String fileType) async {
    try {
      Map body = {"fileType": fileType};

      http.Response response = await http.post(
        //For IOS
        //Uri.parse('http://localhost:5000/generatePresignedUrl'),
        //For Android
        Uri.parse('http://localhost:5000/generatePresignedUrl'),
        headers: {'Content-Type' : 'package.json'},
        body: body,
      );

      var result = jsonDecode(response.body);

      print(result);

      if (result['success'] != null) {
        success = result['success'];
        message = result['message'];

        if (response.statusCode == 201) {
          isGenerated = true;
          uploadUrl = result["XUrl"];
          downloadUrl = result["downloadUrl"];
        }
      }
    } catch (e) {
      throw ('Error getting url');
    }
  }
}

class UploadFile {
  late bool success;
  late String message;

  late bool isUploaded;

  Future<void> call(String url, XFile image) async {
    try {
      File file = File(image.path);
      var response = await http.put(Uri.parse(url), body: file.readAsBytesSync());
      if (response.statusCode == 200) {
        isUploaded = true;
      }
    } catch (e) {
      throw ('Error uploading photo');
    }
  }
}