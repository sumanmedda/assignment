import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newapi_app/pages/detailsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoggedIn = false;
  int selectedValue = 0;
  String maleSel = 'Male';
  String femaleSel = 'Female';

  TextEditingController _fnameController = new TextEditingController();
  TextEditingController _lnameController = new TextEditingController();
  TextEditingController _numberController = new TextEditingController();

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  _login() async {
    try {
      await _googleSignIn.signIn();
      setState(() {
        _isLoggedIn = true;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: _isLoggedIn
              ? SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _fnameController,
                                decoration: InputDecoration(
                                    hintText: 'Enter First Name'),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: _lnameController,
                                decoration: InputDecoration(
                                    hintText: 'Enter Last Name'),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: _numberController,
                                decoration:
                                    InputDecoration(hintText: 'Enter Mobile'),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(children: [
                                Flexible(
                                  child: RadioListTile(
                                      value: 0,
                                      groupValue: selectedValue,
                                      title: Text(maleSel),
                                      onChanged: (value) =>
                                          setState(() => selectedValue = 0)),
                                ),
                                Flexible(
                                  child: RadioListTile(
                                      value: 1,
                                      groupValue: selectedValue,
                                      title: Text(femaleSel),
                                      onChanged: (value) =>
                                          setState(() => selectedValue = 1)),
                                ),
                              ]),
                            ],
                          ),
                        ),
                        // ignore: deprecated_member_use
                        FlatButton(
                          color: Colors.amber,
                          onPressed: () {
                            uploadData();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailsPage(
                                          fname: _fnameController.text.trim(),
                                          lname: _lnameController.text.trim(),
                                          phone: _numberController.text.trim(),
                                          gender: selectedValue == 0
                                              ? 'Male'
                                              : 'Female',
                                        )));
                          },
                          child: Text('Save Details'),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        // ignore: deprecated_member_use
                        // FlatButton(
                        //   color: Colors.amber,
                        //   onPressed: () {
                        //     _logout();
                        //   },
                        //   child: Text('Logout'),
                        // )
                      ],
                    ),
                  ),
                )
              : Center(
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    color: Colors.amber,
                    onPressed: () {
                      _login();
                    },
                    child: Text('Login with Google'),
                  ),
                ),
        ),
      ),
    );
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> uploadData() {
    String gender = selectedValue == 0 ? 'Male' : 'Female';
    return users
        .add({
          'fname': _fnameController.text.trim(),
          'lname': _lnameController.text.trim(),
          'mobile': _numberController.text.trim(),
          'gender': gender,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
