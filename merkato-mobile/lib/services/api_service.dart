import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: dotenv.env['API_URL'] ?? 'http://127.0.0.1:5001',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Auth endpoints
  static Future<Response> register(Map<String, dynamic> data) async {
    return await _dio.post(
      '/api/auth/register',
      data: jsonEncode(data),
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> login(Map<String, dynamic> data) async {
    return await _dio.post(
      '/api/auth/login',
      data: jsonEncode(data),
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> getProfile() async {
    return await _dio.get(
      '/api/auth/profile',
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> updateProfile(Map<String, dynamic> data) async {
    return await _dio.put(
      '/api/auth/profile',
      data: jsonEncode(data),
      options: Options(headers: await _getHeaders()),
    );
  }

  // Product endpoints
  static Future<Response> getProducts({
    String? category,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    final params = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (category != null && category != 'all') 'category': category,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    return await _dio.get(
      '/api/products',
      queryParameters: params,
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> getProduct(String id) async {
    return await _dio.get(
      '/api/products/$id',
      options: Options(headers: await _getHeaders()),
    );
  }

  // Order endpoints
  static Future<Response> createOrder(Map<String, dynamic> data) async {
    return await _dio.post(
      '/api/orders',
      data: jsonEncode(data),
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> getOrder(String id) async {
    return await _dio.get(
      '/api/orders/$id',
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> getOrders() async {
    return await _dio.get(
      '/api/orders',
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> updateOrderStatus(String id, Map<String, dynamic> data) async {
    return await _dio.patch(
      '/api/orders/$id/status',
      data: jsonEncode(data),
      options: Options(headers: await _getHeaders()),
    );
  }

  // Seller product endpoints
  static Future<Response> createProduct(Map<String, dynamic> data) async {
    return await _dio.post(
      '/api/seller/products',
      data: jsonEncode(data),
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> updateProduct(String id, Map<String, dynamic> data) async {
    return await _dio.put(
      '/api/seller/products/$id',
      data: jsonEncode(data),
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> deleteProduct(String id) async {
    return await _dio.delete(
      '/api/seller/products/$id',
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> getSellerProducts() async {
    return await _dio.get(
      '/api/seller/products',
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> getSellerOrders() async {
    return await _dio.get(
      '/api/seller/orders',
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> getSellerAnalytics() async {
    return await _dio.get(
      '/api/seller/analytics',
      options: Options(headers: await _getHeaders()),
    );
  }

  // Cart endpoints
  static Future<Response> getCart() async {
    return await _dio.get(
      '/api/cart',
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> addToCart(Map<String, dynamic> data) async {
    return await _dio.post(
      '/api/cart',
      data: jsonEncode(data),
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> updateCartItem(String id, Map<String, dynamic> data) async {
    return await _dio.put(
      '/api/cart/$id',
      data: jsonEncode(data),
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> removeFromCart(String id) async {
    return await _dio.delete(
      '/api/cart/$id',
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> clearCart() async {
    return await _dio.delete(
      '/api/cart',
      options: Options(headers: await _getHeaders()),
    );
  }

  // Wishlist endpoints
  static Future<Response> getWishlist() async {
    return await _dio.get(
      '/api/wishlist',
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> addToWishlist(Map<String, dynamic> data) async {
    return await _dio.post(
      '/api/wishlist',
      data: jsonEncode(data),
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> removeFromWishlist(String id) async {
    return await _dio.delete(
      '/api/wishlist/$id',
      options: Options(headers: await _getHeaders()),
    );
  }

  // Helper methods
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<void> saveUserData(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user));
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      return jsonDecode(userJson);
    }
    return null;
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }
}