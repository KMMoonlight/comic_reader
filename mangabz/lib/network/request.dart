import 'package:dio/dio.dart';

class DioClient {

  static Dio _dioClient;
  static Dio _dioPhoneClient;

  static Dio getInstance() {

    if (_dioClient == null) {
      Map<String, dynamic> headers = {};
      var options = BaseOptions(
          baseUrl: 'https://www.mangabz.com',
          connectTimeout: 5000,
          receiveTimeout: 3000,
          headers: headers
      );

      _dioClient = Dio(options);
    }

    return _dioClient;
  }

  static Dio getPhoneInstance() {
    if (_dioPhoneClient == null) {
      Map<String, dynamic> headers = {'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1 Edg/89.0.4389.114'};
      var options = BaseOptions(
          baseUrl: 'https://www.mangabz.com',
          connectTimeout: 5000,
          receiveTimeout: 3000,
          headers: headers
      );

      _dioPhoneClient = Dio(options);
    }

    return _dioPhoneClient;
  }



}