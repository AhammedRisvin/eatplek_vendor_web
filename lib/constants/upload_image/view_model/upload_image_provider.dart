// ignore_for_file: depend_on_referenced_packages

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';

import '../../prefferences.dart';

class UploadImageProvider extends ChangeNotifier {
  String imageUrlForUpload = '';
  String progress = '0';
  bool isUploading = false;

  static const String _apiUrl =
      'https://eatplek-server-dev.onrender.com/api/uploads/image';

  Future<String> uploadImageWeb(
    Uint8List bytes,
    String fileName, {
    String folder = 'marketing/banners',
  }) async {
    final dio = Dio();
    try {
      isUploading = true;
      progress = '0';
      notifyListeners();

      final extension = fileName.split('.').last.toLowerCase();
      final imagePart = MultipartFile.fromBytes(
        bytes,
        filename: fileName,
        contentType: MediaType(
          'image',
          extension == 'jpg' ? 'jpeg' : extension,
        ),
      );

      final formData = FormData.fromMap({
        'image': imagePart,
        'width': 800,
        'height': 800,
        'format': extension,
        'quality': 80,
        'folder': folder,
      });

      final response = await dio.post(
        _apiUrl,
        data: formData,
        options: Options(headers: _headers),
        onSendProgress: (sent, total) {
          if (total <= 0) return;
          progress = (sent / total * 100).toStringAsFixed(0);
          notifyListeners();
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final uploadedUrl = _extractImageUrl(response.data);
        debugPrint('Image Upload Successful: $uploadedUrl');
        imageUrlForUpload = uploadedUrl;
        return uploadedUrl;
      }

      debugPrint('Upload Failed: ${response.statusCode} ${response.data}');
      return '';
    } on DioException catch (e) {
      debugPrint('Dio upload error: ${e.message} ${e.response?.data}');
      return '';
    } catch (e) {
      debugPrint('Upload error: $e');
      return '';
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  Future<String> uploadImage(String filePath) async {
    final dio = Dio();
    try {
      isUploading = true;
      progress = '0';
      notifyListeners();

      final fileName = filePath.split('/').last;
      final extension = fileName.split('.').last.toLowerCase();
      final imagePart = await MultipartFile.fromFile(
        filePath,
        filename: fileName,
        contentType: MediaType(
          'image',
          extension == 'jpg' ? 'jpeg' : extension,
        ),
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
        options: Options(headers: _headers),
        onSendProgress: (sent, total) {
          if (total <= 0) return;
          progress = (sent / total * 100).toStringAsFixed(0);
          notifyListeners();
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final uploadedUrl = _extractImageUrl(response.data);
        imageUrlForUpload = uploadedUrl;
        return uploadedUrl;
      }
      return '';
    } on DioException catch (e) {
      debugPrint('Dio upload error: ${e.message} ${e.response?.data}');
      return '';
    } catch (e) {
      debugPrint('Upload error: $e');
      return '';
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  Map<String, String> get _headers {
    if (AppPref.userToken.isEmpty) return {};
    return {'authorization': 'Bearer ${AppPref.userToken}'};
  }

  String _extractImageUrl(dynamic data) {
    if (data is String) return data;
    if (data is! Map) return '';

    final direct = data['url'] ?? data['imageUrl'] ?? data['secure_url'];
    if (direct is String) return direct;

    final nested = data['data'];
    if (nested is Map) {
      final nestedUrl =
          nested['url'] ?? nested['imageUrl'] ?? nested['secure_url'];
      if (nestedUrl is String) return nestedUrl;
    }

    final file = data['file'];
    if (file is Map) {
      final fileUrl = file['url'] ?? file['imageUrl'] ?? file['secure_url'];
      if (fileUrl is String) return fileUrl;
    }

    return '';
  }
}
