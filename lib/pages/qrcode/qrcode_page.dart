import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'generate_qrcode_page.dart';


class QrCodePage extends StatelessWidget {
  const QrCodePage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generate qr code and share',
      showSemanticsDebugger: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController textQr = TextEditingController();
  String textQrCodeScan = "";

  Future<void> scanQrCode() async{
    try{
      final qrCod = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "cancel", true, ScanMode.QR);
      if(qrCod.isNotEmpty){
        print("My code qr : $qrCod");
        textQrCodeScan = qrCod;
        setState(() {

        });
      }
    }on PlatformException{
      print("exception");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Generate qr code and share"),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15,right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.text,
                controller: textQr,
                cursorColor: Theme.of(context).primaryColor,
                decoration: const InputDecoration(
                  hintText: "Enter text",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                      CupertinoPageRoute(builder: (BuildContext context)=>
                          CreateQrCodePage(textQrCode: textQr.text.trim())));
                },
                child: Container(
                  height: 50,
                  color: Theme.of(context).primaryColor,
                  child: const Center(
                    child: Text("Generate",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: ()=> scanQrCode(),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 1
                      )
                  ),
                  child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.document_scanner_outlined,color: Theme.of(context).primaryColor),
                          const SizedBox(width: 10),
                          Text("Scanner",
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor
                            ),
                          ),
                        ],
                      )
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if(textQrCodeScan.isNotEmpty)
                Center(
                  child: Text(textQrCodeScan,
                    style:const TextStyle(
                        fontSize: 16,
                        color: Colors.black
                    ),
                  ),
                )
            ],
          ),
        )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}
