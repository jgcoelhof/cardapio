import 'package:flutter/material.dart';
import 'dart:io';

class CardapioPage extends StatefulWidget {
  const CardapioPage({Key? key}) : super(key: key);

  @override
  State<CardapioPage> createState() => _CardapioPageState();
}

class _CardapioPageState extends State<CardapioPage> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
              onPressed: () {},
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        backgroundColor: const Color(0xffC7411B),
        title: const Text(
          "Cardápio web",
          style: TextStyle(
            fontSize: 24,
            color: Color(0xffFFFFFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 32.0, left: 24),
            child: Text(
              "Novo item",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 24,
                color: Color(0xffC7411B),
              ),
            ),
          ),
          ScrollbarTheme(
            data: ScrollbarThemeData(
              thumbColor: MaterialStateProperty.all<Color>(const Color(
                  0xffFFB987)), // Cor do polegar da barra de rolagem
            ),
            child: Flexible(
              child: Container(
                height: 548,
                child: Scrollbar(
                  thumbVisibility: true,
                  thickness: 6.0,
                  radius: const Radius.circular(8.0),
                  child: Flexible(
                    child: ListView(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 24.0, left: 24, right: 24),
                            child: Container(
                              width: 342,
                              height: 119,
                              decoration: BoxDecoration(
                                color: const Color(0xffFFEFDC),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: _image == null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const[
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 24.0),
                                          child: Text(
                                            "Foto",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xffFFB987),
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.upload,
                                          color: Color(0xffFFB987),
                                        ),
                                      ],
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
