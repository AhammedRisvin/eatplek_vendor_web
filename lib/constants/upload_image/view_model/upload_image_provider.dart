// ignore_for_file: avoid_print, depend_on_referenced_packages
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';

class UploadImageProvider extends ChangeNotifier {
  String imageUrlForUpload = '';
  String progress = '0';
  bool isUploading = false;

  static const String _apiUrl = 'https://api-dev.eatplek.com/api/uploads/image';

  // ── Web upload (bytes) — used in Flutter Web ──────────────────────────────
  Future<String> uploadImageWeb(Uint8List bytes, String fileName) async {
    final Dio dio = Dio();
    try {
      isUploading = true;
      notifyListeners();

      final extension = fileName.split('.').last.toLowerCase();
      final contentType = MediaType('image', extension);

      final imagePart = MultipartFile.fromBytes(
        bytes,
        filename: fileName,
        contentType: contentType,
      );

      final formData = FormData.fromMap({
        'image': imagePart,
        'width': 800,
        'height': 800,
        'format': extension,
        'quality': 80,
        'folder': 'marketing/banners',
      });

      final response = await dio.post(
        _apiUrl,
        data: formData,
        onSendProgress: (sent, total) {
          progress = (sent / total * 100).toStringAsFixed(0);
          notifyListeners();
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Image Upload Successful: ${response.data['data']['url']}');
        isUploading = false;
        return imageUrlForUpload = response.data['data']['url'];
      } else {
        print('❌ Upload Failed: ${response.statusCode}');
        isUploading = false;
        return '';
      }
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      isUploading = false;
      return '';
    } catch (e) {
      print('Upload error: $e');
      isUploading = false;
      return '';
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  // ── Mobile upload (file path) — kept for reference but not used on web ────
  Future<String> uploadImage(String filePath) async {
    final Dio dio = Dio();
    try {
      isUploading = true;
      notifyListeners();

      final fileName = filePath.split('/').last;
      final extension = fileName.split('.').last.toLowerCase();

      final imagePart = await MultipartFile.fromFile(
        filePath,
        filename: fileName,
        contentType: MediaType('image', extension),
      );

      final formData = FormData.fromMap({
        'image': imagePart,
        'width': 800,
        'height': 800,
        'format': extension,
        'quality': 80,
        'folder': 'marketing/banners',
      });

      final response = await dio.post(
        _apiUrl,
        data: formData,
        onSendProgress: (sent, total) {
          progress = (sent / total * 100).toStringAsFixed(0);
          notifyListeners();
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isUploading = false;
        return imageUrlForUpload = response.data['data']['url'];
      }
      isUploading = false;
      return '';
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      isUploading = false;
      return '';
    } catch (e) {
      print('Upload error: $e');
      isUploading = false;
      return '';
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }
}
