import 'dart:io';
import 'dart:math';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:easy_mail_app_frontend/controller/userController.dart';
import 'package:easy_mail_app_frontend/model/addressesModel.dart';
import 'package:easy_mail_app_frontend/screens/postManScreens/mailListPage.dart';
import 'package:easy_mail_app_frontend/screens/userScreens/mails-user.dart';
import 'package:easy_mail_app_frontend/screens/userScreens/userMailBox.dart';
import 'package:easy_mail_app_frontend/shared_widgets/userAppbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:easy_mail_app_frontend/model/userModel.dart';
import 'package:easy_mail_app_frontend/shared_widgets/textfield_widget.dart';
import 'package:easy_mail_app_frontend/shared_widgets/button_widget.dart';
import 'package:easy_mail_app_frontend/model/userModel.dart';
import 'package:easy_mail_app_frontend/shared_widgets/profile_widget.dart';
import 'package:easy_mail_app_frontend/controller/postManController.dart';
// import 'package:user_profile_ii_example/utils/user_preferences.dart';
// import 'package:user_profile_ii_example/widget/appbar_widget.dart';
// import 'package:user_profile_ii_example/widget/button_widget.dart';
// import 'package:user_profile_ii_example/widget/profile_widget.dart';
// import 'package:user_profile_ii_example/widget/textfield_widget.dart';

class RegisterProfilePage extends StatefulWidget {
  final bool isEditing;
  const RegisterProfilePage({Key? key, required this.isEditing})
      : super(key: key);
  static const String route = '/user/register';

  @override
  _RegisterProfilePageState createState() => _RegisterProfilePageState();
  bool getIsEditing() {
    return this.isEditing;
  }
}

class _RegisterProfilePageState extends State<RegisterProfilePage> {
  //PostManController postManController = new PostManController();

  bool _isEditing = false;
  bool _isHidden = true;
  var _addressIds = <String>[];
  var _branchIds = <String>[
    "Mathugama",
    "Colombo",
    "Jaffna",
    "Galle",
    "Mathara",
    "Kandy"
  ];
  UserController userController = new UserController();
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _addressIDController = new TextEditingController();
  TextEditingController _branchIDController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _confirmPasswordController =
      new TextEditingController();
  String? _address;

  @override
  void initState() {
    getAddresses();
    if (_isEditing) {
      print("editing details");
      _userNameController.text = userController.selectedUser[0].username;
      _passwordController.text = userController.selectedUser[0].password;
      _phoneNumberController.text = userController.selectedUser[0].phoneNumber;
      _addressIDController.text = userController.selectedUser[0].addressId;
      _address = userController.selectedUser[0].addressId;
      _emailController.text = userController.selectedUser[0].email;
      _branchIDController.text = userController.selectedUser[0].branchId;
    } else {
      print(_isEditing);
      print("Creating a new user");
      _userNameController.text = "";
      _passwordController.text = "";
      _phoneNumberController.text = "";
      _addressIDController.text = "";
      _address = "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userAppBar(context),
      resizeToAvoidBottomInset: true,
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "User Details",
              style:
                  GoogleFonts.laila(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            //picture(),
            Text("User Name"),
            SizedBox(
              height: 10,
            ),

            userNameField(),
            SizedBox(
              height: 10,
            ),
            Text("Password"),
            passwordField(),
            SizedBox(
              height: 10,
            ),
            Text("Branch ID"),
            Row(
              children: [branchIdField(), branchDropList()],
            ),
            SizedBox(
              height: 10,
            ),
            Text("Address"),
            Row(
              children: [
                addressIdField(),
                dropList(),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Text("Phone Number"),
            phoneNumberField(),
            SizedBox(
              height: 10,
            ),
            Text("Email Address"),
            emailField(),
            SizedBox(
              height: 10,
            ),
            signUpButton(context),
          ],
        ),
      )),
    );
  }

  Widget passwordField() {
    return TextField(
      controller: _passwordController,
      maxLength: 15,
      obscureText: _isHidden,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  Widget userNameField() {
    return TextField(
      controller: _userNameController,
      maxLength: 15,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Saman123",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  Widget emailField() {
    return TextField(
      controller: _emailController,
      maxLength: 25,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "sam@gmail.com",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  Widget addressIdField() {
    return Expanded(
      child: TextField(
        controller: _addressIDController,
        readOnly: true,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Select from drop list",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      ),
    );
  }

  Widget branchIdField() {
    return Expanded(
      child: TextField(
        controller: _branchIDController,
        readOnly: true,
        maxLength: 15,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Select From Drop List",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      ),
    );
  }

  Widget phoneNumberField() {
    return TextField(
      controller: _phoneNumberController,
      maxLength: 10,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "phone number here",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  Widget picture() {
    return ProfileWidget(
      imagePath: "assets/images/default.jpg",
      onClicked: () {},
    );
  }

  Widget dropList() {
    return DropdownButton<String>(
      hint: Text("Select"),
      icon: const Icon(Icons.arrow_drop_down_rounded),
      onTap: getAddresses,
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          //dropdownValue = newValue!;
          _addressIDController.text = newValue!;
          print(newValue);
        });
      },
      items: _addressIds.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget branchDropList() {
    return DropdownButton<String>(
      hint: Text("Select"),
      icon: const Icon(Icons.arrow_drop_down_rounded),
      onTap: getAddresses,
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          //dropdownValue = newValue!;
          getAddressesWithBranch(newValue);
          _branchIDController.text = newValue!;
          print(newValue);
        });
      },
      items: _branchIds.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget signUpButton(BuildContext context) {
    return Material(
      elevation: 10.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFF000000),
      child: MaterialButton(
        minWidth: 20,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        onPressed: () async {
          if (_userNameController.text.toString() == "" ||
              _phoneNumberController.text.toString() == "" ||
              _branchIDController.text.toString() == "") {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fill The all details')));
          } else {
            if (RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(_emailController.text)) {
              submit(context);
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Invalid Email')));
            }
          }
        },
        child: Text("Sign up",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void getAddresses() async {
    //_addressIds.add("dd");
    await userController.getLocations();
    _addressIds.clear();
    for (Address address in userController.addresses) {
      _addressIds.add(address.addressId.toString());
    }
    setState(() {});

    //_addressIds.add("default");
    print(_addressIds);
  }

  void getAddressesWithBranch(branchId) async {
    //_addressIds.add("dd");
    await userController.getLocationsWithBranch(branchId);
    _addressIds.clear();
    for (Address address in userController.addresses) {
      _addressIds.add(address.addressId.toString());
    }
    setState(() {});

    //_addressIds.add("default");
    print(_addressIds);
  }

  void register(User user, context) async {
    var result = await userController.register(user);
    if (result.err == 1) {
      //await userController.updateProfile(user);
      var msg = result.msg;
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$msg')));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MailsUserPage()));
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully registered')));
    }
    // print(_confirmPasswordController);
    // print(_passwordController);
  }

  void submit(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Enter the password Again"),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                            controller: _confirmPasswordController),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("Submit"),
                          onPressed: () {
                            if (_passwordController.text.toString() ==
                                    _confirmPasswordController.text
                                        .toString() &&
                                _confirmPasswordController.text.toString() !=
                                    "") {
                              User user = new User(
                                  username: _userNameController.text,
                                  status: true,
                                  email: _emailController.text,
                                  phoneNumber: _phoneNumberController.text,
                                  addressId: _addressIDController.text,
                                  branchId: _branchIDController.text,
                                  password: _passwordController.text);
                              register(user, context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Check the Passwod Again')));
                              Navigator.pop(context);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
