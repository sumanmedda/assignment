import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
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
          ],
        ),
      ),
    );
  }
}
