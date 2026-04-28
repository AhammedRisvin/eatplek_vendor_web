// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'colors.dart';
import 'common_widget.dart';
import 'prefferences.dart';
import 'router.dart';

class ServerClient {
  static const int _timeout = 180;

  static Map<String, String> _buildHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (AppPref.userToken.isNotEmpty) {
      headers['authorization'] = 'Bearer ${AppPref.userToken}';
    }
    return headers;
  }

  static void _handleSessionExpired(BuildContext context, List response) {
    if (response.first == 399 || response.first == 401) {
      AppPref.isSignedIn = false;
      AppPref.userToken = '';
      context.goNamed(AppRouter.login);
    }
  }

  // ── GET ───────────────────────────────────────────────────────────────────
  static Future<List> get(String url, BuildContext context) async {
    log(
      'GET: $url | token: ${AppPref.userToken.isNotEmpty ? "present" : "missing"}',
    );
    try {
      final response = await http
          .get(Uri.parse(url), headers: _buildHeaders())
          .timeout(const Duration(seconds: _timeout));
      final data = await _response(response);
      log('GET response: ${data.first}');
      _handleSessionExpired(context, data);
      return data;
    } catch (e) {
      log('GET error: $e');
      _showNetworkError(context, e);
      return [600, e.toString()];
    }
  }

  // ── POST ──────────────────────────────────────────────────────────────────
  static Future<List> post(
    String url, {
    Map<String, dynamic>? data,
    bool post = true,
    required BuildContext context,
  }) async {
    log('POST: $url | body: $data');
    try {
      final body = json.encode(data);
      final response = await http
          .post(
            Uri.parse(url),
            body: post ? body : null,
            headers: _buildHeaders(),
          )
          .timeout(const Duration(seconds: _timeout));
      final returnResponse = await _response(response);
      log('POST response: ${returnResponse.first}');
      _handleSessionExpired(context, returnResponse);
      return returnResponse;
    } catch (e) {
      log('POST error: $e');
      _showNetworkError(context, e);
      return [600, e.toString()];
    }
  }

  // ── PUT ───────────────────────────────────────────────────────────────────
  static Future<List> put(
    String url, {
    Map<String, dynamic>? data,
    bool put = false,
    required BuildContext context,
  }) async {
    log('PUT: $url | body: $data');
    try {
      final body = json.encode(data);
      final response = await http
          .put(
            Uri.parse(url),
            body: put ? null : body,
            headers: _buildHeaders(),
          )
          .timeout(const Duration(seconds: _timeout));
      final returnResponse = await _response(response);
      log('PUT response: ${returnResponse.first}');
      _handleSessionExpired(context, returnResponse);
      return returnResponse;
    } catch (e) {
      log('PUT error: $e');
      _showNetworkError(context, e);
      return [600, e.toString()];
    }
  }

  // ── PATCH ─────────────────────────────────────────────────────────────────
  static Future<List> patch(
    String url, {
    Map<String, dynamic>? data,
    bool patch = false,
    required BuildContext context,
  }) async {
    log('PATCH: $url | body: $data');
    try {
      final body = json.encode(data);
      final response = await http
          .patch(
            Uri.parse(url),
            body: patch ? null : body,
            headers: _buildHeaders(),
          )
          .timeout(const Duration(seconds: _timeout));
      final returnResponse = await _response(response);
      log('PATCH response: ${returnResponse.first}');
      _handleSessionExpired(context, returnResponse);
      return returnResponse;
    } catch (e) {
      log('PATCH error: $e');
      _showNetworkError(context, e);
      return [600, e.toString()];
    }
  }

  // ── DELETE ────────────────────────────────────────────────────────────────
  static Future<List> delete(
    String url, {
    Map<String, dynamic>? data,
    required BuildContext context,
  }) async {
    log('DELETE: $url');
    try {
      final jsonData = data != null ? json.encode(data) : null;
      final response = await http
          .delete(Uri.parse(url), headers: _buildHeaders(), body: jsonData)
          .timeout(const Duration(seconds: _timeout));
      final returnResponse = await _response(response);
      log('DELETE response: ${returnResponse.first}');
      _handleSessionExpired(context, returnResponse);
      return returnResponse;
    } catch (e) {
      log('DELETE error: $e');
      _showNetworkError(context, e);
      return [600, e.toString()];
    }
  }

  // ── Network error helper ──────────────────────────────────────────────────
  static void _showNetworkError(BuildContext context, dynamic e) {
    final msg = e.toString().toLowerCase();
    final isNetwork =
        msg.contains('failed to fetch') ||
        msg.contains('socketexception') ||
        msg.contains('network') ||
        msg.contains('connection');
    toast(
      context,
      title: isNetwork
          ? 'Please check your internet connection'
          : 'Server error, please try again',
      backgroundColor: AppColor.red,
    );
  }

  // ── Response parser ───────────────────────────────────────────────────────
  static Future<List> _response(http.Response response) async {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = {'message': response.body};
    }

    final msg = body is Map
        ? (body['message'] ?? body['error'] ?? 'Unknown error')
        : 'Unknown error';

    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
        return [response.statusCode, body];
      case 399:
      case 400:
      case 401:
      case 403:
        return [response.statusCode, msg];
      case 404:
        return [response.statusCode, msg];
      case 500:
        return [response.statusCode, msg];
      case 502:
        return [response.statusCode, 'Server crashed or under maintenance'];
      case 503:
      case 504:
        return [response.statusCode, 'Server timeout, please try again'];
      default:
        return [response.statusCode, msg];
    }
  }
}
