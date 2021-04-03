import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newapi_app/pages/registerPage.dart';
import 'package:shimmer/shimmer.dart';

Future<List<Country>> fetchCountry() async {
  final response = await http.get(Uri.https('restcountries.eu', 'rest/v2/all'));
  if (response.statusCode == 200) {
    List<Country> countries;

    countries = (json.decode(response.body) as List)
        .map((i) => Country.fromJson(i))
        .toList();
    return countries;
  } else {
    throw Exception('Failed to load country');
  }
}

class Country {
  final String name;
  final String capital;
  final String flag;

  Country({required this.name, required this.capital, required this.flag});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      capital: json['capital'],
      flag: json['flag'],
    );
  }
}

class DetailsPage extends StatefulWidget {
  final String fname;
  final String lname;
  final String phone;
  final String gender;

  const DetailsPage(
      {Key? key,
      required this.fname,
      required this.lname,
      required this.phone,
      required this.gender})
      : super(key: key);
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Future<List<Country>> countries;

  @override
  void initState() {
    super.initState();
    countries = fetchCountry();
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  _logout() async {
    try {
      _googleSignIn.signOut();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => RegisterPage()));
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Homepage'),
        ),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: ListView(
              children: [
                Column(children: [
                  Text('First Name : ' + widget.fname),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text('Last Name : ' + widget.lname),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text('Mobile : ' + widget.phone),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text('Gender : ' + widget.gender),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Country Details:',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 25.0,
                    ),
                  ),
                  FutureBuilder<List<Country>>(
                      future: countries,
                      builder: (context, countrySnap) {
                        if (countrySnap.hasData) {
                          return Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: new ListView.builder(
                                    itemCount: countrySnap.data?.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Text('Name : ' +
                                              countrySnap.data![index].name),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text('Capital : ' +
                                              countrySnap.data![index].capital),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              print(countrySnap
                                                  .data![index].flag);
                                            },
                                            child: Text(
                                              countrySnap.data![index].flag,
                                            ),
                                          ),
                                          SvgPicture.network(countrySnap
                                              .data![index].flag
                                              .toString()),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                              // ignore: deprecated_member_use
                              FlatButton(
                                  color: Colors.amber,
                                  onPressed: () {
                                    _logout();
                                  },
                                  child: Text('Logout')),
                            ],
                          );
                        } else if (countrySnap.hasError) {
                          return Text("${countrySnap.error}");
                        }
                        return Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: Shimmer.fromColors(
                                  // Wrap your widget into Shimmer.
                                  baseColor: Colors.grey[200]!,
                                  highlightColor: Colors.grey[350]!,
                                  child: new ListView.builder(
                                    itemCount: 10,
                                    itemBuilder: (context, index) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 48.0,
                                            height: 48.0,
                                            color: Colors.white,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: double.infinity,
                                                  height: 8.0,
                                                  color: Colors.white,
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2.0),
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  height: 8.0,
                                                  color: Colors.white,
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2.0),
                                                ),
                                                Container(
                                                  width: 40.0,
                                                  height: 8.0,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      })
                ]),
              ],
            )));
  }
}
