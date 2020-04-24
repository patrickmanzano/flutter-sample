import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() => runApp(new MaterialApp(
  debugShowCheckedModeBanner: false,
  home: BcrmErrorCode(),
));

Future<String> fetchBinaryCodes(String filePath) async {
  final response = rootBundle.loadString(filePath);
  return response;
}

class BcrmErrorCode extends StatefulWidget {
  @override
  _BcrmErrorCodeState createState() => _BcrmErrorCodeState();
}

class _BcrmErrorCodeState extends State<BcrmErrorCode> {
  final myController = TextEditingController();
  final myErrorCode = TextEditingController();
  final myErrorName = TextEditingController();
  final myCause = TextEditingController();
  final mySecondCause = TextEditingController();
  Map<String, dynamic> binary4XXCodes = new HashMap<String, dynamic>();
  Map<String, dynamic> binary5XXCodes = new HashMap<String, dynamic>();

  @override
  void initState() {
    //loadCauses();
    super.initState();
    myController.addListener(_printLatestValue);
    myErrorCode.addListener(_printLatestValue);
    myErrorName.addListener(_printLatestValue);
    myCause.addListener(_printLatestValue);
    mySecondCause.addListener(_printLatestValue);

    fetchBinaryCodes('assets/data/4XXStatusCodes.json').then((binaryJson) {
      parseStatusData(binaryJson, '4XX');
    });


    // Use '5XX' to store all fixed code values
    // to single Map (binary5XXCodes) for multiple json files.
    fetchBinaryCodes('assets/data/50XStatusCodes.json').then((binaryJson) {
      parseStatusData(binaryJson, '5XX');
    });
    fetchBinaryCodes('assets/data/51XStatusCodes.json').then((binaryJson) {
      parseStatusData(binaryJson, '5XX');
    });
  }

  parseStatusData(String responseBody, String code) {
    switch(code){
      case '4XX':
        setState(() {
          binary4XXCodes.addAll(json.decode(responseBody));
        });
        break;
      case '5XX':
        setState(() {
          binary5XXCodes.addAll(json.decode(responseBody));
        });
        break;
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    myController.dispose();
    myErrorCode.dispose();
    myErrorName.dispose();
    myCause.dispose();
    mySecondCause.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    myController.text = "";
    myErrorCode.text = "";
    myErrorName.text = "";
    myCause.text = "";
    mySecondCause.text = "";
    return Scaffold(
      appBar: AppBar(
        title: Text('BCRM Error Code'),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.blue[900],
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                autofocus: true,
                inputFormatters: [
                  new WhitelistingTextInputFormatter(RegExp("[a-zA-Z,0-9]")),
                  new BlacklistingTextInputFormatter(new RegExp('[\\.,]')),
                ],
                textCapitalization: TextCapitalization.characters,
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
                    focusedBorder:
                    OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(5)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(5))),
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
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Text(
                                myErrorName.text,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                          decoration: BoxDecoration(color: Colors.yellowAccent),
                          child: ListView(
                            children: <Widget>[
                              Text(
                                myCause.text,
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 10),
                              Text(mySecondCause.text, style: TextStyle(fontSize: 15)),
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
      }),
    );
  }

  void _printLatestValue() {
    if (myController.text.length == 7) {
      myErrorCode.text = myController.text.toUpperCase();
      String errorCodeAsString = myErrorCode.text;

      // Default value
      String errorCodeName = '';
      String errorCodeDesc = '';
      String errorCodeDesc2 = errorCodeDesc;

      if(errorCodeAsString.substring(0, 1) == '4'){
        // ----- START OF 4XX ------
        print("this is errorCodeAsString " + errorCodeAsString.substring(0, 1));

        if (binary4XXCodes.containsKey(errorCodeAsString.substring(0, 3))) {

          var binaryEntry = binary4XXCodes[errorCodeAsString.substring(0, 3)];

          String _n1 = (int.parse(errorCodeAsString[3], radix: 16).toRadixString(2).padLeft(4, '0'));
          String _m1 = (int.parse(errorCodeAsString[4], radix: 16).toRadixString(2).padLeft(4, '0'));
//          print(binaryEntry.toString() + "\n");

          if (errorCodeAsString.substring(0, 1) == '4') {
            if (binaryEntry['desc'] != null) {
              errorCodeName = binaryEntry['desc'];
            }
          }
          if (binaryEntry['n'] != null && binaryEntry['n'].length > 0 && _n1 != '0000') {
            //binary checking for N
            for (int i = 0; i < _n1.length; i++) {
              if (_n1[i] == '1') {
                if (binaryEntry['n'][i].toString().length > 0) {
                  String bx = 'b' + (4 - i).toString();
                  errorCodeDesc = errorCodeDesc + binaryEntry['n'][i][bx].toString();
                }
              }
            }
          }
          if (binaryEntry['m'] != null && binaryEntry['m'].length > 0 && _m1 != '0000') {
            //binary checking for M
            for (int i = 0; i < _m1.length; i++) {
              if (_m1[i] == '1') {
                if (binaryEntry['m'][i] != null) {
                  String bx = 'b' + (4 - i).toString();
                  errorCodeDesc = errorCodeDesc + binaryEntry['m'][i][bx].toString();
                }
              }
            }
          }
          if (binaryEntry['x'] != null) {
            // Check x input
            if (errorCodeAsString[5] == '1') {
              errorCodeDesc = errorCodeDesc + binaryEntry['x'][0]['1'].toString();
            } else if (errorCodeAsString[5] == '2') {
              errorCodeDesc = errorCodeDesc + binaryEntry['x'][1]['2'].toString();
            }
          }
          if (binaryEntry['y'] != null) {
            errorCodeDesc2 = binaryEntry['y'];
          }
        }

        // ----- END OF 4XX ------
      } else if(errorCodeAsString.substring(0, 1) == '5'){
        // ----- START OF 5XX ------
        // 5XX Map keys contains the actual/fixed value
        if(binary5XXCodes.containsKey(errorCodeAsString)){
          var binaryEntry = binary5XXCodes[errorCodeAsString];
          if (binaryEntry['desc'] != null) {
            errorCodeName = binaryEntry['desc'];
          }
          if (binaryEntry['x'] != null) {
            errorCodeDesc = errorCodeDesc + binaryEntry['x'];
          }
          if (binaryEntry['y'] != null) {
            errorCodeDesc = errorCodeDesc + binaryEntry['y'];
          }
          // ----- END OF 5XX ------
        }
      }
      //"${errorCodeAsString[0]}"
      // Check if 4xx is in JSON file e.g 400, 401

      // Empty desc - display no data instead.
      if (errorCodeDesc == '') {
        errorCodeDesc = 'NO DATA';
        errorCodeDesc2 = 'NO DATA';
      }
      myErrorName.text = errorCodeName;
      myCause.text = errorCodeDesc;
      mySecondCause.text = errorCodeDesc2;
    }
  }
}
