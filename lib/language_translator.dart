import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';

class TranslatorApp extends StatefulWidget {
  const TranslatorApp({Key? key});

  @override
  State<TranslatorApp> createState() => _TranslatorAppState();
}

class _TranslatorAppState extends State<TranslatorApp> {
  List<String> languages = [
    'English',
    'Hindi',
    'Arabic',
    'German',
    'Russian',
    'Spanish',
    'Urdu',
    'Japanese',
    'Italian'
  ];
  List<String> languagescode = [
    'en',
    'hi',
    'ar',
    'de',
    'ru',
    'es',
    'ur',
    'ja',
    'it'
  ];

  final translator = GoogleTranslator();

  String from = 'en';
  String to = 'hi';
  String data = 'आप कैसे हैं?';
  String selectedvalue = 'English';
  String selectedvalue2 = 'Hindi';

  TextEditingController controller =
  TextEditingController(text: 'How are you?');
  final formkey = GlobalKey<FormState>();
  bool isloading = false;

  Future<void> fetchData() async {
    try {
      var response = await http.post(
        Uri.parse(
            'https://google-translate1.p.rapidapi.com/language/translate/v2'),
        headers: {
          'Content-Type': 'application/json',
          'X-RapidAPI-Key':
          'bfe6385b10msha292bbfea9989b2p1ba5d9jsn2dc9f86b633a', // Replace with your actual RapidAPI key
          'X-RapidAPI-Host': 'google-translate1.p.rapidapi.com',
        },
        body: jsonEncode({
          'q': ['${controller.text}'],
          'source': from,
          'target': to,
        }),
      );

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        var translations = decodedData['data']['translations'];
        if (translations.isNotEmpty) {
          data = translations[0]['translatedText'];
        } else {
          data = 'Translation not available';
        }
        setState(() {});
      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
        // You can handle error cases and set appropriate messages.
      }
    } on SocketException catch (_) {
      isloading = true;
      SnackBar mysnackbar = const SnackBar(
        content: Text('Internet not Connected'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(mysnackbar);
      setState(() {});
    }
  }

  translate() async {
    try {
      if (formkey.currentState!.validate()) {
        await fetchData(); // Call the fetchData function before translation

        var translation =
        await translator.translate(controller.text, from: from, to: to);
        data = translation.text;
        isloading = false;
        setState(() {});
      }
    } on SocketException catch (_) {
      isloading = true;
      SnackBar mysnackbar = const SnackBar(
        content: Text('Internet not Connected'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(mysnackbar);
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff003366),
        title: Text(
          "Language Translator",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                    color: Color(0x0c6750a4),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('From'),
                    const SizedBox(
                      width: 100,
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: selectedvalue,
                        focusColor: Colors.transparent,
                        items: languages.map((lang) {
                          return DropdownMenuItem(
                            value: lang,
                            child: Text(lang),
                            onTap: () {
                              if (lang == languages[0]) {
                                from = languagescode[0];
                              } else if (lang == languages[1]) {
                                from = languagescode[1];
                              } else if (lang == languages[2]) {
                                from = languagescode[2];
                              } else if (lang == languages[3]) {
                                from = languagescode[3];
                              } else if (lang == languages[4]) {
                                from = languagescode[4];
                              } else if (lang == languages[5]) {
                                from = languagescode[5];
                              } else if (lang == languages[6]) {
                                from = languagescode[6];
                              } else if (lang == languages[7]) {
                                from = languagescode[7];
                              } else if (lang == languages[8]) {
                                from = languagescode[8];
                              }
                              setState(() {
                                // print(lang);
                                // print(from);
                              });
                            },
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedvalue = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Color(0x0c6750a4),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black)),
                child: Form(
                  key: formkey,
                  child: TextFormField(
                    controller: controller,
                    maxLines: null,
                    minLines: null,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        errorBorder: InputBorder.none,
                        errorStyle: TextStyle(color: Colors.white)),
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                    color: Color(0x0c6750a4),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('To'),
                    const SizedBox(
                      width: 100,
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: selectedvalue2,
                        focusColor: Colors.transparent,
                        items: languages.map((lang) {
                          return DropdownMenuItem(
                            value: lang,
                            child: Text(lang),
                            onTap: () {
                              if (lang == languages[0]) {
                                to = languagescode[0];
                              } else if (lang == languages[1]) {
                                to = languagescode[1];
                              } else if (lang == languages[2]) {
                                to = languagescode[2];
                              } else if (lang == languages[3]) {
                                to = languagescode[3];
                              } else if (lang == languages[4]) {
                                to = languagescode[4];
                              } else if (lang == languages[5]) {
                                to = languagescode[5];
                              } else if (lang == languages[6]) {
                                to = languagescode[6];
                              } else if (lang == languages[7]) {
                                to = languagescode[7];
                              } else if (lang == languages[8]) {
                                to = languagescode[8];
                              }
                              setState(() {
                                print(lang);
                                print(from);
                              });
                            },
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedvalue2 = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Color(0x0c6750a4),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black)),
                child: Center(
                  child: SelectableText(
                    data,
                    style: const TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                    onPressed: translate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF6600),
                    ),
                    child: isloading
                        ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      'Translate',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          )),
    );
  }
}
