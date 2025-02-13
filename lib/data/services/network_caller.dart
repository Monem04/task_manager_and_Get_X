import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_manager/application/app.dart';
import 'package:task_manager/presentation/controllers/auth_controller.dart';
import 'package:task_manager/presentation/screens/onboarding_screens/sign_in_screen.dart';

import '../models/network_response.dart';

class NetworkCaller{
  static Future<NetworkResponse> getRequest({required String url}) async {
    Uri uri = Uri.parse(url);
    debugPrint(url);
    Map<String, String>headers = {
      "token": AuthController.accessToken.toString(),
    };
    final Response response = await get(uri, headers: headers);

    printResponseInConsole(url, response);

    try{
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true, 
          statusCode: response.statusCode, 
          responseData: decodedData,
        );
      } else if(response.statusCode == 401){
        _moveToLogin();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: "Please login to continue",
        );
      } else {
        final decodedData = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedData["data"],
        );
      }
    }catch(e){
      return NetworkResponse(
          isSuccess: false,
          statusCode: -1,
          errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> postRequest({required String url, Map<String, dynamic>? body}) async {
    Uri uri = Uri.parse(url);
    debugPrint(url);

    Map<String, String>headers = {
      "Content-type":"application/json",
      "token": AuthController.accessToken.toString(),
    };
    final Response response = await post(
      uri,
      headers:headers,
      body: jsonEncode(body),
    );

    printResponseInConsole(url, response);

    try{
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        if(decodedData["status"] == "fail"){
          return NetworkResponse(isSuccess: false, statusCode: response.statusCode, errorMessage: decodedData["data"]);
        }
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      } else if(response.statusCode == 401){
         _moveToLogin();
         return NetworkResponse(
             isSuccess: false,
             statusCode: response.statusCode,
             errorMessage: "Please login to continue",
         );
      }else{
        final decodedData = jsonDecode(response.body);
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: decodedData["data"],
        );
      }
    }catch(e){
      return NetworkResponse(
          isSuccess: false,
          statusCode: -1,
          errorMessage: e.toString(),
      );
    }
  }

  static void printResponseInConsole(String url, Response response) {
    debugPrint("URL: $url \n ResponseCode: ${response.statusCode} \n ResponseBody: ${response.body}");
  }
  static Future<void> _moveToLogin() async {
    await AuthController.clearUserData();
    Navigator.pushAndRemoveUntil(TaskManager.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context)=>const LoginScreen()), (value)=>false);
  }
}