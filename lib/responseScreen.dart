import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'node.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

late Box<Node> box;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NodeAdapter());
  box = await Hive.openBox<Node>('app_decision_map');
  
  // POPULATE LIST CODE
  String csv = "app_decision_map.csv";
  String fileData = await rootBundle.loadString(csv);
  print(fileData); // test data is loaded.

  List<String> rows = fileData.split("\n");
  for (int i = 0; i < rows.length; i++) {
    // selects an item from row and places
    String row = rows[i];
    List<String> itemInRow = row.split(",");

    Node node = Node(
      int.parse(itemInRow[0]),
      int.parse(itemInRow[1]),
      int.parse(itemInRow[2]),
      itemInRow[3],
      itemInRow[4],
    );

    int key = int.parse(itemInRow[0]);
    box.put(key, node);
  }

  runApp(
    const MaterialApp(
      home: MyFlutterApp(),
    ),
  );
}

class MyFlutterApp extends StatefulWidget {
  const MyFlutterApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyFlutterState();
  }
}

class MyFlutterState extends State<MyFlutterApp> {
  late int iD;
  late int yesID;
  late int noID;
  String question = "";
  String extra = "";

  @override
  void initState() {
    super.initState();
    // Load initial data from the database
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        Node? current = box.get(1);
        if (current != null) {
          iD = current.iD;
          yesID = current.yesID;
          noID = current.noID;
          question = current.question;
          extra = current.extra;
        }
      });
    });
  }

  void yesHandler() {
    setState(() {
      Node? nextNode = box.get(yesID);
      if (nextNode != null && nextNode.iD == yesID) {
        iD = nextNode.iD;
        yesID = nextNode.yesID;
        noID = nextNode.noID;
        question = nextNode.question;
        extra = nextNode.extra;
      }
    });
  }

  void noHandler() {
    setState(() {
      Node? nextNode = box.get(noID);
      if (nextNode != null && nextNode.iD == noID) {
        iD = nextNode.iD;
        yesID = nextNode.yesID;
        noID = nextNode.noID;
        question = nextNode.question;
        extra = nextNode.extra;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff9fcf91),
      appBar: AppBar(
        elevation: 10,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff6f9065),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Text(
          "Home",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 18,
            color: Color(0xffffffff),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.home,
            color: Color(0xffffffff),
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      question,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 22,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
                  child: Text(
                    extra,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
                  child: MaterialButton(
                    onPressed: yesHandler,
                    color: Color(0xff5b9388),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0),
                      side: BorderSide(color: Color(0xff808080), width: 1),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "YES",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    textColor: Color(0xff493d34),
                    height: 70,
                    minWidth: 170,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: MaterialButton(
                    onPressed: noHandler,
                    color: Color(0xff4b4a67),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0),
                      side: BorderSide(color: Color(0xff808080), width: 1),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "NO",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    textColor: Color(0xffddd1c7),
                    height: 70,
                    minWidth: 170,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// Reference to the desision tree data:https://www.actualfirstaid.com/uploads/1/0/4/9/104966051/first_aid_notes_2019.pdf