import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

void main() => runApp(BcrmErrorCode());

Future<String> fetchBinaryCodes() async {
  final response =
  rootBundle.loadString('../assets/data/4XXStatusCodes.json');
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

  Map<String,dynamic> binaryCodes;

  @override
  void initState() {
    //loadCauses();
    super.initState();
    myController.addListener(_printLatestValue);
    myErrorCode.addListener(_printLatestValue);
    myErrorName.addListener(_printLatestValue);
    myCause.addListener(_printLatestValue);

    fetchBinaryCodes().then((binaryJson) {
      parseStatusData(binaryJson);
    });
  }

  parseStatusData(String responseBody) {
    setState(() {
      binaryCodes = json.decode(responseBody);
    });
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
    myErrorCode.text = "";
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
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints viewportConstraints) {
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
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 10),
                              Text('Next to check', style: TextStyle(fontSize: 20)),
                              SizedBox(height: 10),
//                              FutureBuilder<NextCause>(
//                                future: loadNextCause(),
//                                builder: (context, snapshot) {
//                                  if (snapshot.hasData) {
//                                    return new Container(
//                                        padding: new EdgeInsets.all(20.0),
//                                        child: new Row(
//                                          children: <Widget>[
//                                            Text(
//                                                "The next cause are ${snapshot.data.id} and ${snapshot.data.causes}")
//                                          ],
//                                        ));
//                                  } else if (snapshot.hasError) {
//                                    return new Text("${snapshot.error}");
//                                  }
//                                  return new CircularProgressIndicator();
//                                },
//                              ),
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

      myErrorCode.text = myController.text;
      String errorCodeAsString = myErrorCode.text;

      String _n1 = (int.parse(errorCodeAsString[3], radix: 16).toRadixString(2).padLeft(4, '0'));
      String _m1 = (int.parse(errorCodeAsString[4], radix: 16).toRadixString(2).padLeft(4, '0'));

      // Default value
      String errorCodeName = '';
      String errorCodeDesc = '';

      // Check if 4xx is in JSON file e.g 400, 401
      if(binaryCodes.containsKey(errorCodeAsString.substring(0,3))){

        var binaryEntry = binaryCodes[errorCodeAsString.substring(0,3)];

        if(binaryEntry['desc'] != null){
          errorCodeName = binaryEntry['desc'];
        }

        if(binaryEntry['n']!= null && binaryEntry['n'].length > 0 && _n1 != '0000') {
          //binary checking for N
          for (int i = 0; i < _n1.length; i++) {
            if (_n1[i] == '1') {
              if(binaryEntry['n'][i].toString().length >0 ){
                String bx = 'b' + (4 - i).toString();
                errorCodeDesc =
                    errorCodeDesc + '\n' + binaryEntry['n'][i][bx].toString();
              }
            }
          }
          errorCodeDesc = errorCodeDesc + '\n';
        }

        if(binaryEntry['m'] != null  && binaryEntry['m'].length > 0 && _m1 != '0000') {
          //binary checking for M
          for (int i = 0; i < _m1.length; i++) {
            if (_m1[i] == '1') {
              if(binaryEntry['m'][i] != null) {
                String bx = 'b' + (4 - i).toString();
                errorCodeDesc =
                    errorCodeDesc + '\n' + binaryEntry['m'][i][bx].toString();
              }
            }
          }
        }

        if(binaryEntry['x'] !=null && binaryEntry['x'].length > 0) {
          // Check x input
          errorCodeDesc = errorCodeDesc + '\n\n';
          int x = errorCodeAsString[5] == '2' ? 2 : 1;
          //x-1 is index position of array in JSON x entries.
          errorCodeDesc =
              errorCodeDesc + binaryEntry['x'][x - 1][x.toString()].toString();
        }
      }

      myErrorName.text = errorCodeName;

      // Empty desc - display no data instead.
      if(errorCodeDesc == ''){
        errorCodeDesc = 'NO DATA';
      }
      myCause.text = errorCodeDesc;

    }
  }
}
//
//class NextCause {
//  final String id;
//  final List<String> cause;
//
//  NextCause({this.id, this.cause});
//
//  factory NextCause.fromJson(Map<String, dynamic> getJson) {
//    return NextCause(
//      id: getJson['id'],
//      cause: getCause(getJson['causes']),
//    );
//  }
//
//  static List<String> getCause(causeJson) {
//    List<String> causeList = new List<String>.from(causeJson);
//    return causeList;
//  }
//}
