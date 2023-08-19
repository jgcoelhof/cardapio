import 'dart:io';
import 'dart:typed_data';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';


class CreateQrCodePage extends StatefulWidget {
  final String? textQrCode;
  const CreateQrCodePage({Key? key,this.textQrCode}) : super(key: key);

  @override
  State<CreateQrCodePage> createState() => _CreateQrCodePageState();
}

class _CreateQrCodePageState extends State<CreateQrCodePage> {
  final GlobalKey globalKey = GlobalKey();

  Future<void> converQrCodeToImage() async{
    RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    File imgFile  = File("$directory/qrCode.png");
    await imgFile.writeAsBytes(pngBytes);
    await Share.shareFiles([imgFile.path],text:"Your text share");

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Qr code scrren"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15,right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: RepaintBoundary(
                  key: globalKey,
                  child: QrImage(
                    data: "${widget.textQrCode}",
                    version: QrVersions.auto,
                    size: 200,
                    backgroundColor: Colors.white,
                    gapless: true,
                    errorStateBuilder: (cxt, err){
                      return const Center(
                        child: Text("Error"),
                      );
                    },
                  ),
                )
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => converQrCodeToImage(),
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
                      Icon(Icons.share_outlined, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 10),
                      Text("Convert qr code to image and Share",style: TextStyle(
                          color: Theme.of(context).primaryColor
                      ),)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
