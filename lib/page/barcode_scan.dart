import 'dart:convert';

import 'package:barcode_sample/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class BarcodeScanPage extends StatefulWidget {
  @override
  _BarcodeScanPageState createState() => _BarcodeScanPageState();
}

class _BarcodeScanPageState extends State<BarcodeScanPage> {
  String barcode = 'データなし';
  TextEditingController kosu = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('バーコード　スキャン'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 12),
              ButtonWidget(
                text: 'スキャン　開始',
                onClicked: scanBarcode,
              ),
              SizedBox(height: 72),
              Text(
                'スキャン結果',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '$barcode',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all()
                  ),
                  child: TextFormField(
                    controller: kosu,
                    decoration: InputDecoration(
                      hintText: '個数を入力',
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                child: Text('発注メールを送信する'),
                onPressed: () {
                  urlLauncherMail();
                },
              ),
            ],
          ),
        ),
      );

  urlLauncherMail() {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'tanakakakukuei@gmail.com',
      queryParameters: {
        'subject': '発注書',
        'body': '$barcodeを${kosu.text}個,発注します。'
      },
    );

    return launch(
      _emailLaunchUri.toString(),
    );
  }



  Future<void> scanBarcode() async {
    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );

      if (!mounted) return;

      setState(() {
        this.barcode = barcode;
      });
    } on PlatformException {
      barcode = 'Failed to get platform version.';
    }
  }
}
