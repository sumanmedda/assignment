import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Country>> fetchCountry() async {
  final response = await http.get(Uri.https('restcountries.eu', 'rest/v2/all'));
  if (response.statusCode == 200) {
    List<Country> countries;

    countries = (json.decode(response.body) as List)
        .map((i) => Country.fromJson(i))
        .toList();
    print(countries);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Homepage'),
        ),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(children: [
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
                'Countries Details:',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 25.0,
                ),
              ),
              FutureBuilder<List<Country>>(
                  future: countries,
                  builder: (context, countrySnap) {
                    if (countrySnap.connectionState == ConnectionState.none &&
                        // ignore: unnecessary_null_comparison
                        countrySnap.hasData == null) {
                      return CircularProgressIndicator();
                    }
                    return SingleChildScrollView(
                      child: Expanded(
                        child: SizedBox(
                          height: 500,
                          //child: Shimmer.fromColors(
                          child: ListView.builder(
                            itemCount: countrySnap.data!.length,
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
                                  Text('Flag : ' +
                                      countrySnap.data![index].flag),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              );
                            },
                          ),
                          // baseColor: Colors.amber,
                          // highlightColor: Colors.orange,
                        ),
                      ),
                      // ),
                    );
                  })
            ])));
  }
}
