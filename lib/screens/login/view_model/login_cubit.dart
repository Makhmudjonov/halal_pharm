import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_storage/get_storage.dart';
import 'package:yangidarsmart25/model/login_req_service_model.dart';
import 'package:yangidarsmart25/service/ILoginReqService.dart';

class LoginCubit extends Cubit<LoginState> {
  GlobalKey<FormState> formKey;
  TextEditingController usernameController;
  TextEditingController passwordController;

  bool isLoginFail = false;
  bool isLoading = false;

  final ILoginService service;

  LoginCubit(
    this.formKey,
    this.usernameController,
    this.passwordController, {
    required this.service,
  }) : super(LoginInitial());

  Future<void> postUserModel() async {
    if (formKey.currentState!.validate()) {
      changeLoadingView();
      try {
        final data = await service.postUserLogin(
          LoginRequestModel(
            email: usernameController.text,
            password: passwordController.text,
          ),
        );
        if ((data as Map).keys.toList()[0] == 'token') {
          GetStorage().write('token', data['token']);
          emit(LoginComplete());
        } else {
          // eve.holt@reqres.in
          emit(LoginErrorState("Parol Xato !!"));
        }
      } catch (e) {
        emit(LoginErrorState("Login parol xato !!"));
      }

      changeLoadingView();
      print("BAJARILDI");
    } else {
      isLoginFail = true;
      emit(LoginValidateState(isLoginFail));
    }
  }

  void changeLoadingView() {
    isLoading = !isLoading;
    emit(LoginValidateState(isLoginFail));
  }
}

// * STATEGA AJRATIB CHIQARISHIMIZ MUMKIN

abstract class LoginState {
  LoginState();
}

class LoginInitial extends LoginState {
  LoginInitial();
}

class LoginValidateState extends LoginState {
  bool isLoginFail;
  LoginValidateState(this.isLoginFail);
}

class LoginErrorState extends LoginState {
  String errMessage;
  LoginErrorState(this.errMessage);
}

class LoginComplete extends LoginState {
  LoginComplete();
}
