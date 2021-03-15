import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as misc_utils;
import 'package:url_launcher/url_launcher.dart';

class MiscUtils {
  static String convertDate(String time) {
    return misc_utils.DateFormat.d()
        .add_E()
        .add_jm()
        .format(DateTime.parse(time))
        .toString();
  }

  static launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static String getRandomId(int size) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

    return List.generate(size, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  static Future<File> compressImage(
      String path, String name, String extension) async {
    return await FlutterImageCompress.compressAndGetFile(path, name,
        minWidth: 1000,
        minHeight: 1000,
        quality: 80,
        format: extension == 'png' ? CompressFormat.png : CompressFormat.jpeg);
  }

  static Future pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    File croppedFile;
    if (pickedFile != null) {
      croppedFile = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          compressFormat: ImageCompressFormat.png,
          maxHeight: 1080,
          maxWidth: 1080,
          compressQuality: 80,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
    }
    if (croppedFile != null) {
      return File(croppedFile.path);
    } else {
      return null;
    }
  }

  static int findPercentageOfTwoNumbers(int small, int big) {
    return ((1 - (small / big)) * 100).round();
  }
}
