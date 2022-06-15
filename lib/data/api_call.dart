import 'package:dio/dio.dart';

class APICall {
  Dio? dio;

  APICall() {
    BaseOptions options = BaseOptions(
        baseUrl: "https://www.breakingbadapi.com/api/",
        receiveDataWhenStatusError: true,
        connectTimeout: 20 * 1000,
        receiveTimeout: 20 * 1000);

    dio = Dio(options);
  }

  Future<List<dynamic>> getData() async {
    try {
      Response response = await dio!.get("characters");
      print("Success");
      print(response.data.toString());
      return response.data;
    } catch (e) {
      print("Error");
      return [];
    }
  }

  Future<List<dynamic>> getQuote(String characterName) async {
    try {
      Response response =
          await dio!.get("quote", queryParameters: {"author": characterName});
      print("Success");
      print(response.data.toString());
      return response.data;
    } catch (e) {
      print("Error");
      return [];
    }
  }
}
