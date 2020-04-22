import 'package:flutter/material.dart';

void main() => runApp(BcrmErrorCode());

class BcrmErrorCode extends StatefulWidget {
  @override
  _BcrmErrorCodeState createState() => _BcrmErrorCodeState();
}

class _BcrmErrorCodeState extends State<BcrmErrorCode> {
  final myController = TextEditingController();
  final myErrorCode = TextEditingController();
  final myErrorName = TextEditingController();
  final myCause = TextEditingController();

  String _errorcode = "";
  String _errorstart = "";
  String _n = "";
  String _m = "";
  String _x = "";
  String _n1 = "";
  String _m1 = "";
  String _n10 = "";
  String _n11 = "";
  String _n12 = "";
  String _n13 = "";
  String _m10 = "";
  String _m11 = "";
  String _m12 = "";
  String _m13 = "";
  String _n10C = "";
  String _n11C = "";
  String _n12C = "";
  String _n13C = "";
  String _m10C = "";
  String _m11C = "";
  String _m12C = "";
  String _m13C = "";
  String _x1 = "";
  String _x2 = "";

  @override
  void initState() {
    super.initState();
    myController.addListener(_printLatestValue);
    myErrorCode.addListener(_printLatestValue);
    myErrorName.addListener(_printLatestValue);
    myCause.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    myController.dispose();
    myErrorCode.dispose();
    myErrorName.dispose();
    myCause.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    myController.text = "";
    myErrorName.text = "";
    myCause.text = "";
    return Scaffold(
      appBar: AppBar(
        title: Text('BCRM Error Code'),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.blue[900],
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: myController,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLength: 7,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      counter: Offstage(),
                      contentPadding: const EdgeInsets.all(10),
                      hintText: "TYPE BCRM CODE HERE...",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(5)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(5))),
                ),
                SizedBox(height: 5),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(color: Colors.grey),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(color: Colors.red),
                          child: Row(
                            children: <Widget>[
                              Text(
                                myErrorCode.text + " ",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Text(
                                  myErrorName.text,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            decoration:
                            BoxDecoration(color: Colors.yellowAccent),
                            child: ListView(
                              children: <Widget>[
                                Text(
                                  myCause.text,
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _printLatestValue() {
//    if (myController.text.length == null) {
//      myErrorName.text = "";
//      myCause.text = "";
//    }

    if (myController.text.length == 7) {
      myErrorCode.text = myController.text;

      _n = "${_errorcode[3]}";
      _m = "${_errorcode[4]}";
      _x = "${_errorcode[5]}";

      //Convert _n and _m to binary
      _n1 = (int.parse('$_n', radix: 16).toRadixString(2).padLeft(4, '0'));
      _m1 = (int.parse('$_m', radix: 16).toRadixString(2).padLeft(4, '0'));

      _n10 = "${_n1[0]}";
      _n11 = "${_n1[1]}";
      _n12 = "${_n1[2]}";
      _n13 = "${_n1[3]}";
      _m10 = "${_m1[0]}";
      _m11 = "${_m1[1]}";
      _m12 = "${_m1[2]}";
      _m13 = "${_m1[3]}";

      if ("${_errorcode[0]}${_errorcode[1]}${_errorcode[2]}" == "400") {
        myErrorName.text = " - HCM Sensor/echo error";

        if ('$_n10' == '1') {
          _n10C = " - CS Feeding notes shift sensor (Left) (S105) Error\n";
        } else {
          _n10C = "";
        }
        if ('$_n11' == '1') {
          _n11C = " - CS Feeding notes shift sensor (Right) (S106) Error\n";
        } else {
          _n11C = "";
        }
        if ('$_n12' == '1') {
          _n12C = " - CS Feeding notes skew sensor (Left) (S103) Error\n";
        } else {
          _n12C = "";
        }
        if ('$_n13' == '1') {
          _n13C = " - CS Feeding notes skew sensor (Right) (S104) Error\n";
        } else {
          _n13C = "";
        }

        if ('$_m10' == '1') {
          _m10C = " - TS Stacker entrance sensor (Left) (S201) Error\n";
        } else {
          _m10C = "";
        }
        if ('$_m11' == '1') {
          _m11C = " - TS Stacker entrance sensor (Right) (S202) Error\n";
        } else {
          _m11C = "";
        }
        if ('$_m12' == '1') {
          _m12C = " - CS Stacker entrance sensor (Left) (S121) Error\n";
        } else {
          _m12C = "";
        }
        if ('$_m13' == '1') {
          _m13C = " - CS Stacker entrance sensor (Right) (S122) Error\n";
        } else {
          _m13C = "";
        }

        if ('$_x' == '1') {
          _x1 = " - dark check error";
        } else {
          _x1 = "";
        }
        if ('$_x' == '2') {
          _x2 = " - pattern check error";
        } else {
          _x2 = "";
        }

        myCause.text =
        ("$_n10C$_n11C$_n12C$_n13C$_m10C$_m11C$_m12C$_m13C$_x1$_x2");
      }
    }
  }
}
