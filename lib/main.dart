import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:ussd_service/ussd_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WTF Emei check',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final emeiController = TextEditingController();
  final List goodOnes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EMEI check"),
      ),
      body: Column(
        children: <Widget>[
          const Text(
            "Enter the list of emei to check",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              minLines: 8,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              controller: emeiController,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                contentPadding: EdgeInsets.all(5),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: () async {
                String emeis = (emeiController.text);
                List emei_list = emeis.split("\n");
                // showDialog(
                //     context: context,
                //     builder: (context) {
                //       return const AlertDialog(
                //         content: Text(
                //             "Please wait verying the supplied emei numbers"),
                //       );
                //     });#195*1*${emie}
                for (var emie in emei_list) {
                  try {
                    String? res = await UssdAdvanced.sendAdvancedUssd(
                        code: "*#195*1*$emie#", subscriptionId: 1);
                    if (res!.contains("number")) {
                      setState(() {
                        goodOnes.add(emie);
                      });
                    }
                  } catch (e) {
                    debugPrint("${e}");
                  }
                }
              },
              child: Container(
                  color: Colors.blue,
                  padding: const EdgeInsets.all(4),
                  child: const Text(
                    "Check",
                    style: TextStyle(color: Colors.white),
                  ))),
          const SizedBox(
            height: 40,
          ),
          if (goodOnes.isNotEmpty) ...[
            const Text(
              "Found",
              style: TextStyle(fontSize: 24),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(5),
              width: double.infinity,
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              child: Column(
                children: [for (String lfound in goodOnes) Text(lfound)],
              ),
            )
          ]
        ],
      ),
    );
  }
}
