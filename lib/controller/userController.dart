import 'package:easy_mail_app_frontend/model/addressesModel.dart';
import 'package:easy_mail_app_frontend/model/postManModel.dart';
import 'package:easy_mail_app_frontend/model/tokenModel.dart';
import 'package:easy_mail_app_frontend/model/userModel.dart';
import 'package:get/get.dart';
import '../model/mailModel.Dart';
import '../model/addressModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserController extends GetxController {
  var mails = <MailModel>[].obs;
  var selectedUser = <User>[].obs;
  var addresses = <Address>[].obs;
  // User user = new User();
  static String? token;
  static String? userName;

  Future register(User user) async {
    print(user.username);
    try {
      var response = await http.post(
        Uri.parse("http://10.0.2.2:5000/api/user/register"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: user.toRawJson(),
      );

      var result = TokenRes.fromRawJson(response.body);
      token = result.token;
      userName = user.username;

      print(token);
      return result.err;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future login(String username, String password) async {
    print(username);
    try {
      var response = await http.post(
        Uri.parse("http://10.0.2.2:5000/api/user/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(
            <String, String>{'username': "$username", "password": "$password"}),
      );

      var result = TokenRes.fromRawJson(response.body);
      token = result.token;
      userName = username;

      print(token);
      return result.err;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future getSentMails() async {
    mails.clear();
    try {
      var response = await http.get(
          Uri.parse("http://10.0.2.2:5000/api/user/sent-mails/$userName"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            "mailID": "mail002",
            "x-auth-token": "$token"
          });
      // print(response);
      // List data = json.decode(response.body);
      // print(data);
      var result = Result.fromRawJson(response.body);
      //print(result);
      //print("${result.mailModel[0].mailId}jfdsdfsdfdf ");
      mails.addAll(result.mailModel);
      print(mails.length.toString() + "results found");
      return (result.msg);
    } on Exception catch (e) {
      print(e);
    }

    return;
  }

  Future getSentMoneyOrders(String mailID) async {
    return;
  }

  Future getReceivedMoneyOrders(String mailID) async {
    return;
  }

  Future getReceivedMails() async {
    mails.clear();
    try {
      var response = await http.get(
          Uri.parse("http://10.0.2.2:5000/api/user/mailbox/$userName"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            "mailID": "mail002",
            "x-auth-token": "$token"
          });
      // print(response);
      // List data = json.decode(response.body);
      // print(data);
      var result = Result.fromRawJson(response.body);
      //print(result);
      //print("${result.mailModel[0].mailId}jfdsdfsdfdf ");
      mails.addAll(result.mailModel);
      print(mails.length.toString() + "results found");
      print(result.msg);
      return (result.msg);
    } on Exception catch (e) {
      print(e);
    }

    return;
  }

  Future changeMyAddressID(String addressID) async {
    return;
  }

  Future getUser(userName) async {
    selectedUser.clear();
  }

  Future updateUser(User user) async {
    selectedUser.clear();
    selectedUser.add(user);
    print(user.username);
  }

  Future registerUser(User user) async {
    print(user.username);
  }

  Future getLocations() async {
    addresses.clear();
    print("getting all locations");
    try {
      var response = await http.get(
          Uri.parse("http://10.0.2.2:5000/api/postman/address/"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            "x-auth-token": "$token"
          });

      var result = AddressList.fromRawJson(response.body);
      print(result.addresses);

      addresses.addAll(result.addresses);
      print(addresses.length.toString() + "results found");
      return (result);
    } on Exception catch (e) {
      print(e);
    }
  }
}
