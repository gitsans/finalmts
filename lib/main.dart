import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() {
  runApp(new MaterialApp(home: new MyApp(), routes: <String, WidgetBuilder>{
    "/second": (BuildContext context) => new Ticket(),
    "/third": (BuildContext context) => new Recharge()
  }));
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('1st'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('welcome to the app'),
            Center(
              child: RaisedButton(
                child: Text('Recharge metro card'),
                onPressed: () {
                  Navigator.of(context).pushNamed("/third");
                },
              ),
            ),
            Center(
              child: RaisedButton(
                child: Text('Generate online ticket'),
                onPressed: () {
                  Navigator.of(context).pushNamed("/second");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Ticket extends StatefulWidget {
  @override
  TicketState createState() => new TicketState();
}

class TicketState extends State<Ticket> {
  final TextEditingController controller = new TextEditingController();
  var upicode = "xyz";
  var mwallet = 80.0;
  var res = "";
  void result() {}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2nd'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
              controller: controller,
              decoration: InputDecoration(hintText: 'Enter UPI'),
              onSubmitted: (String str) {
                setState(() {
                  res = str;
                });
                controller.text = "";
              }),
          res == upicode
              ? mwallet >= 80.0
                  ? QrImage(
                      data: res,
                      size: 200,
                    )
                  : Text('Insufficent amount')
              : Text('Incorrect Code'),
          RaisedButton(
              child: Text('Back'),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }
}

class Recharge extends StatefulWidget {
  @override
  RechargeState createState() => new RechargeState();
}

class RechargeState extends State<Recharge> {
  String barcode = "";
  double amt = 200;
  double val;
  var mwallet = 280.0;
  Future scanBarcode() async {
    String barcodeResult = await FlutterBarcodeScanner.scanBarcode(
        "##ff6666", "Cancel", true, ScanMode.QR);
    setState(() {
      barcode = barcodeResult;
    });
  }

  void scanpress() {
    if (val >= 200.0 && mwallet >= val) {
      mwallet = mwallet - val;
      scanBarcode();
    } else {
      print('Insufficient amount');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('3rd'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
              decoration: new InputDecoration(labelText: "Enter the amount"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
              onSubmitted: (String str) {
                setState(() {
                  var num = double.parse(str);
                  val = num;
                });
              }),
          RaisedButton(
            child: Text('Scan'),
            onPressed: scanpress,
          ),
        ],
      ),
    );
  }
}
