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

  // ── Core request handler ──────────────────────────────────────────────────
  static Future<List> _request(
    String method,
    String url, {
    Map<String, dynamic>? data,
    bool sendBody = true,
    required BuildContext context,
  }) async {
    final headers = _buildHeaders();
    final String? encodedBody = (sendBody && data != null)
        ? json.encode(data)
        : null;

    log('┌─── API REQUEST ───────────────────────────────');
    log('│ Method  : $method');
    log('│ URL     : $url');
    log('│ Headers : $headers');
    log('│ Body    : ${encodedBody ?? 'none'}');
    log('└───────────────────────────────────────────────');

    try {
      final http.Response response;
      final uri = Uri.parse(url);
      const duration = Duration(seconds: _timeout);

      switch (method) {
        case 'GET':
          response = await http.get(uri, headers: headers).timeout(duration);
        case 'POST':
          response = await http
              .post(uri, body: encodedBody, headers: headers)
              .timeout(duration);
        case 'PUT':
          response = await http
              .put(uri, body: encodedBody, headers: headers)
              .timeout(duration);
        case 'PATCH':
          response = await http
              .patch(uri, body: encodedBody, headers: headers)
              .timeout(duration);
        case 'DELETE':
          response = await http
              .delete(uri, body: encodedBody, headers: headers)
              .timeout(duration);
        default:
          throw UnsupportedError('Unsupported HTTP method: $method');
      }

      final parsed = await _response(response);

      log('┌─── API RESPONSE ──────────────────────────────');
      log('│ Method  : $method');
      log('│ URL     : $url');
      log('│ Status  : ${response.statusCode}');
      log('│ Body    : ${response.body}');
      log('└───────────────────────────────────────────────');

      _handleSessionExpired(context, parsed);
      return parsed;
    } catch (e) {
      log('┌─── API ERROR ─────────────────────────────────');
      log('│ Method  : $method');
      log('│ URL     : $url');
      log('│ Error   : $e');
      log('└───────────────────────────────────────────────');
      _showNetworkError(context, e);
      return [600, e.toString()];
    }
  }

  // ── Public HTTP methods ───────────────────────────────────────────────────

  static Future<List> get(String url, BuildContext context) =>
      _request('GET', url, context: context);

  static Future<List> post(
    String url, {
    Map<String, dynamic>? data,
    bool sendBody = true,
    required BuildContext context,
  }) => _request('POST', url, data: data, sendBody: sendBody, context: context);

  static Future<List> put(
    String url, {
    Map<String, dynamic>? data,
    bool sendBody = true,
    required BuildContext context,
  }) => _request('PUT', url, data: data, sendBody: sendBody, context: context);

  static Future<List> patch(
    String url, {
    Map<String, dynamic>? data,
    bool sendBody = true,
    required BuildContext context,
  }) =>
      _request('PATCH', url, data: data, sendBody: sendBody, context: context);

  static Future<List> delete(
    String url, {
    Map<String, dynamic>? data,
    required BuildContext context,
  }) => _request('DELETE', url, data: data, context: context);

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
