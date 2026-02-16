import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:oktoast/oktoast.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import '../../app/utils/helper.dart';

class ImageService {
  static Future<Uint8List?> capture({GlobalKey? key}) async {
    if (key == null) return null;
    final boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 8);
    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final pngByte = byteData?.buffer.asUint8List();
    return pngByte;
  }

  static Future<void> openFile(String filePath) async {
    // Open the file with the gallery app
    // log("open file path : $filePath");
    final permission = await getPermission(Permission.photos);
    if (!permission) return;

    // final _status =
    try {
      await OpenFile.open(filePath);
    } catch (e) {
      //
    }

    // log("open file : ${_status.message}");
  }

  static Future<bool> getPermission(Permission per) async {
    double version = double.tryParse((await _getAndVer) ?? '') ?? 0;

    Permission permission = per;

    if ((per == Permission.photos ||
            per == Permission.videos ||
            per == Permission.mediaLibrary ||
            per == Permission.camera) &&
        version <= 12) {
      permission = Permission.storage;
    }

    PermissionStatus permissionStatus = await permission.status;
    // print("PermissionStatus === $_permission=========== $permissionStatus");

    if (!permissionStatus.isGranted) {
      permissionStatus = await permission.request();
    }

    if (permissionStatus.isGranted) {
      return true;
    } else {
      showToast("Permission denied");
      return false;
    }
  }

  static Future<String?> get _getAndVer async {
    String? version;

    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;

      version = androidInfo.version.release;
    }
    // else if (Platform.isIOS) {
    //   final iosInfo = await deviceInfo.iosInfo;
    //   _version = iosInfo.systemVersion;
    // } else if (Platform.isMacOS) {
    //   final macInfo = await deviceInfo.macOsInfo;
    //   _version = macInfo.kernelVersion;
    // }
    return version;
  }

  // static Future<String?> compressFile(
  //   String oldpath, {
  //   int height = 300,
  //   int width = 300,
  // }) async {
  //   final dir = await path_provider.getTemporaryDirectory();
  //   final targetPath = "${dir.absolute.path}/temp.jpg";

  //   var result = await FlutterImageCompress.compressAndGetFile(
  //     oldpath,
  //     targetPath,
  //     quality: 85, // Adjust the quality between 0-100
  //     minWidth: width, // Target width
  //     minHeight: height, // Target height
  //   );

  //   return result?.path;
  // }

  //pick files from file manager or use camera or use gallery //show dialog
  static Future<List<PlatformFile>?> pickFiles(
      {required FileType mediaType}) async {
    final permission = await getPermission(Permission.mediaLibrary);
    if (!permission) return null;

    final result = mediaType == FileType.image
        ? await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: mediaType,
          )
        : await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: mediaType,
            allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
          );
    if (result == null) return null;
    return result.files.first.path == null ? null : result.files;
  }

  //take picture from camera
  static Future<String?> takePicture() async {
    final permission = await getPermission(Permission.camera);
    if (!permission) return null;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return null;
    return pickedFile.path;
  }

//ios
  static Future<void> startDownload({
    String? file,
    required String name,
    required String ext,
    required MimeType mimeType,
    required String url,
  }) async {
    if (mimeType == MimeType.jpeg) {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return;
      final bytes = response.bodyBytes;
      final per = await getPermission(Permission.photos);
      if (!per) return;
      final resul = await ImageGallerySaverPlus.saveImage(
          Uint8List.fromList(bytes),
          quality: 95,
          name: name,
          isReturnImagePathOfIOS: false);
      if (resul != null) {
        showToast("Download completed");
      }
    } else {
      final permission = await Helper.requestStoragePermissions();
      if (!permission) return;
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return;
      final bytes = response.bodyBytes;
      await FileSaver.instance
          .saveAs(
        bytes: bytes,
        name: name,
        mimeType: mimeType,
        fileExtension: ext,
      )
          .then(
        (value) {
          if (value != null) {
            showToast("Download completed");
          }
        },
      );
    }
  }
}

enum ImageSaveType { download, share, print }
