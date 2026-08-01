import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static Dio? _dioInstance;
  
  static Dio get dio {
    if (_dioInstance == null) {
      _dioInstance = Dio(BaseOptions(
        baseUrl: 'https://merkato-link.onrender.com',
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ));
      
      // Add interceptor for automatic token attachment
      _dioInstance!.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            // Add token to all requests except register and login
            if (!options.path.contains('/api/auth/register') && 
                !options.path.contains('/api/auth/login')) {
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('token');
              if (token != null) {
                options.headers['Authorization'] = 'Bearer $token';
              }
            }
            options.headers['Content-Type'] = 'application/json';
            return handler.next(options);
          },
          onError: (error, handler) async {
            // Handle 401 errors - token expired or invalid
            if (error.response?.statusCode == 401) {
              // Clear invalid token and redirect to login
              await clearToken();
              await clearUserData();
              // You could add navigation logic here
            }
            return handler.next(error);
          },
        ),
      );
    }
    return _dioInstance!;
  }

  static Future<Map<String, String>> _getHeaders() async {
    return {
      'Content-Type': 'application/json',
    };
  }

  // Auth endpoints
  static Future<Response> register(Map<String, dynamic> data) async {
    return await dio.post(
      '/api/auth/register',
      data: jsonEncode(data),
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> login(Map<String, dynamic> data) async {
    return await dio.post(
      '/api/auth/login',
      data: jsonEncode(data),
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> getProfile() async {
    return await dio.get(
      '/api/auth/profile',
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> updateProfile(Map<String, dynamic> data) async {
    return await dio.put(
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

    return await dio.get(
      '/api/products',
      queryParameters: params,
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> getProduct(String id) async {
    return await dio.get(
      '/api/products/$id',
      options: Options(headers: await _getHeaders()),
    );
  }

  // Order endpoints
  static Future<Response> createOrder(Map<String, dynamic> data) async {
    return await dio.post(
      '/api/orders',
      data: jsonEncode(data),
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> getOrder(String id) async {
    return await dio.get(
      '/api/orders/$id',
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> getOrders() async {
    return await dio.get(
      '/api/orders',
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> updateOrderStatus(String id, Map<String, dynamic> data) async {
    return await dio.patch(
      '/api/orders/$id/status',
      data: jsonEncode(data),
      options: Options(headers: await _getHeaders()),
    );
  }

  // Seller product endpoints
  static Future<Response> createProduct(Map<String, dynamic> data) async {
    return await dio.post(
      '/api/seller/products',
      data: jsonEncode(data),
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> updateProduct(String id, Map<String, dynamic> data) async {
    return await dio.put(
      '/api/seller/products/$id',
      data: jsonEncode(data),
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> deleteProduct(String id) async {
    return await dio.delete(
      '/api/seller/products/$id',
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> getSellerProducts() async {
    return await dio.get(
      '/api/seller/products',
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> getSellerOrders() async {
    return await dio.get(
      '/api/seller/orders',
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> getSellerAnalytics() async {
    return await dio.get(
      '/api/seller/analytics',
      options: Options(headers: await _getHeaders()),
    );
  }

  // Cart endpoints
  static Future<Response> getCart() async {
    return await dio.get(
      '/api/cart',
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> addToCart(Map<String, dynamic> data) async {
    return await dio.post(
      '/api/cart',
      data: jsonEncode(data),
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> updateCartItem(String id, Map<String, dynamic> data) async {
    return await dio.put(
      '/api/cart/$id',
      data: jsonEncode(data),
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> removeFromCart(String id) async {
    return await dio.delete(
      '/api/cart/$id',
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> clearCart() async {
    return await dio.delete(
      '/api/cart',
      options: Options(headers: await _getHeaders()),
    );
  }

  // Wishlist endpoints
  static Future<Response> getWishlist() async {
    return await dio.get(
      '/api/wishlist',
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> addToWishlist(Map<String, dynamic> data) async {
    return await dio.post(
      '/api/wishlist',
      data: jsonEncode(data),
      options: Options(headers: await _getHeaders()),
    );
  }

  static Future<Response> removeFromWishlist(String id) async {
    return await dio.delete(
      '/api/wishlist/$id',
      options: Options(headers: await _getHeaders()),
    );
  }

  // Generic GET method
  static Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    return await dio.get(
      endpoint,
      queryParameters: queryParameters,
      options: Options(headers: await _getHeaders()),
    );
  }

  // Generic POST method
  static Future<Response> post(String endpoint, {Map<String, dynamic>? data}) async {
    return await dio.post(
      endpoint,
      data: data != null ? jsonEncode(data) : null,
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