import 'dart:io';
import 'package:dio/dio.dart';
import 'package:yangidarsmart25/model/login_req_service_model.dart';
import 'package:yangidarsmart25/service/ILoginReqService.dart';

class LoginServie extends ILoginService {
  LoginServie(Dio dio) : super(dio);

  @override
  Future postUserLogin(LoginRequestModel model) async {
    final Response response = await dio.post(loginPath, data: model);

    if (response.statusCode == HttpStatus.ok) {
      return response.data;
    } else {
      return null;
    }
  }
}
