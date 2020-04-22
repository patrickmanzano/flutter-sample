import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class StatusCode {
  String code;
  String error;
  String action;

  StatusCode({this.code, this.error, this.action});

  factory StatusCode.fromJson(Map<String, dynamic> json) {
    return new StatusCode(
      code: json['code'],
      error: json['error'],
      action: json['action'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['error'] = this.error;
    data['action'] = this.action;
    return data;
  }
}

Future<String> fetchStatusCode() async {
  final response =
  rootBundle.loadString('../assets/data/cmdv4Statusdisplayatnormal.json');
  // Use the compute function to run parsePhotos in a separate isolate
  return response;
}

Future<String> fetchBinaryCodes() async {
  final response =
  rootBundle.loadString('../assets/data/4XXStatusCodes.json');
  return response;
}

Future wait(int seconds) {
  return new Future.delayed(Duration(seconds: seconds), () => {});
}

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myController = TextEditingController();
  final myErrorCode = TextEditingController();
  final myErrorName = TextEditingController();
  final myCause = TextEditingController();

  List<StatusCode> allRecord;
  Map<String,dynamic> binaryCodes;

  parseStatusData(String responseBody, bool isStatus) {
    if(isStatus){

      final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
      setState(() {
        allRecord = parsed
            .map<StatusCode>((json) => new StatusCode.fromJson(json))
            .toList();
      });
    }else{
      setState(() {
        binaryCodes = json.decode(responseBody);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    myController.addListener(_printLatestValue);
    myErrorCode.addListener(_printLatestValue);
    myErrorName.addListener(_printLatestValue);
    myCause.addListener(_printLatestValue);
    fetchStatusCode().then((String) {
      parseStatusData(String, true);
    });
    fetchBinaryCodes().then((binaryJson) {
      parseStatusData(binaryJson, false);
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
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
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
                                  myErrorName.text + " ",
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
                            height: MediaQuery
                                .of(context)
                                .size
                                .height,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            decoration:
                            BoxDecoration(color: Colors.yellowAccent),
                            child: ListView(
                              children: <Widget>[
                                Text(
                                  myCause.text + " ",
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

    if (myController.text.length == 7) {

      myErrorCode.text = myController.text;
      String errorCodeAsString = myErrorCode.text;

      String _n1 = (int.parse(errorCodeAsString[3], radix: 16).toRadixString(2).padLeft(4, '0'));
      String _m1 = (int.parse(errorCodeAsString[4], radix: 16).toRadixString(2).padLeft(4, '0'));

      String errorCodeDesc = '';

      // Check if 4xx is in JSON file e.g 400, 401
      if(binaryCodes.containsKey(errorCodeAsString.substring(0,3))){

        var binaryEntry = binaryCodes[errorCodeAsString.substring(0,3)];
        myErrorName.text = binaryEntry['desc'];

        //binary checking for N
        errorCodeDesc = errorCodeDesc + _n1+ " \n ";
        for(int i =0; i < _n1.length; i++){
          if(_n1[i] == '1'){
            String bx  = 'b' + (4-i).toString();
            errorCodeDesc = errorCodeDesc + '\n' +  binaryEntry['n'][i][bx].toString();
          }
        }
        errorCodeDesc = errorCodeDesc+ '\n';

        //binary checking for M
        errorCodeDesc = errorCodeDesc + _m1+ " \n ";
        for(int i =0; i < _m1.length; i++){
          if(_m1[i] == '1'){
            String bx  = 'b' + (4-i).toString();
            errorCodeDesc = errorCodeDesc + '\n' + binaryEntry['m'][i][bx].toString();
          }
        }

        // Check x input
        errorCodeDesc = errorCodeDesc+ '\n';
        int x = errorCodeAsString[5] == '2' ? 2 : 1;
        //x-1 is index position of array in JSON x entries.
        errorCodeDesc = errorCodeDesc + binaryEntry['x'][x-1][x.toString()].toString();

        myCause.text = errorCodeDesc;
      }
    }
  }
}
