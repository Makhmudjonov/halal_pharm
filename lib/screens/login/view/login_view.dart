import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yangidarsmart25/core/components/input_comp.dart';
import 'package:yangidarsmart25/screens/login/view_model/login_cubit.dart';
import 'package:yangidarsmart25/service/I_login_service.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final String baseUrl = 'https://reqres.in/api';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(
        formKey,
        usernameController,
        passwordController,
        service: LoginServie(Dio(BaseOptions(baseUrl: baseUrl))),
      ),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errMessage),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is LoginComplete) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Muvaffaqiyatli kirildi..."),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.green,
                      title: Text(GetStorage().read('token') ?? ""),
                    ),
                  ),
                ),
                (route) => false);
          }
        },
        builder: (context, state) {
          return buildScaffoldMethod(context, state);
        },
      ),
    );
  }

  Scaffold buildScaffoldMethod(BuildContext context, LoginState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
        leading: Visibility(
          visible: context.watch<LoginCubit>().isLoading,
          child: const CircularProgressIndicator(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          autovalidateMode: state is LoginValidateState
              ? (state.isLoginFail
                  ? AutovalidateMode.always
                  : AutovalidateMode.onUserInteraction)
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: usernameController,
                decoration: InputComp.myDecoration(
                  "Username",
                  "Username Kiriting....",
                ),
                validator: (v) =>
                    (v ?? '').length > 6 ? null : "Username Kam kiritildi !",
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              TextFormField(
                controller: passwordController,
                decoration: InputComp.myDecoration(
                  "Password",
                  "Password Kiriting....",
                ),
                validator: (v) =>
                    (v ?? '').length > 6 ? null : "Username Kam kiritildi !",
              ),
              ElevatedButton(
                child: const Text("Sign In"),
                onPressed: context.watch<LoginCubit>().isLoading
                    ? null
                    : () {
                        context.read<LoginCubit>().postUserModel();
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
