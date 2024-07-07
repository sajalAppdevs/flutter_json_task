import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter JSON Task',
      home: JsonParsingScreen(),
    );
  }
}

class JsonParsingScreen extends StatefulWidget {
  @override
  _JsonParsingScreenState createState() => _JsonParsingScreenState();
}

class _JsonParsingScreenState extends State<JsonParsingScreen> {
  // Define static JSON inputs
  static const String input1 = '''
  [
    {"0": {"id": 1, "title": "Gingerbread"}, "1": {"id": 2, "title": "Jellybean"}, "3": {"id": 3, "title": "KitKat"}},
    [{"id": 4, "title": "Lollipop"}, {"id": 5, "title": "Pie"}, {"id": 6, "title": "Oreo"}, {"id": 7, "title": "Nougat"}]
  ]
  ''';

  static const String input2 = '''
  [
    {"0": {"id": 1, "title": "Gingerbread"}, "1": {"id": 2, "title": "Jellybean"}, "3": {"id": 3, "title": "KitKat"}},
    {"0": {"id": 8, "title": "Froyo"}, "2": {"id": 9, "title": "Éclair"}, "3": {"id": 10, "title": "Donut"}},
    [{"id": 4, "title": "Lollipop"}, {"id": 5, "title": "Pie"}, {"id": 6, "title": "Oreo"}, {"id": 7, "title": "Nougat"}]
  ]
  ''';

  List<AndroidVersion> parsedData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepOrange[500],
        title: Text('Flutter JSON Task'),
        elevation: 15,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => _parseJson(input1),
                child: Text('Input 1'),
              ),
              ElevatedButton(
                onPressed: () => _parseJson(input2),
                child: Text('Input 2'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: parsedData.length,
                  itemBuilder: (context, index) {
                    final version = parsedData[index];
                    return ListTile(
                      title: Text(version.title ?? ''),
                      subtitle: Text('ID: ${version.id}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _parseJson(String jsonString) {
    final List<dynamic> jsonData = json.decode(jsonString);

    final List<AndroidVersion> versions = [];

    for (final item in jsonData) {
      if (item is List) {
        for (final subItem in item) {
          versions.add(AndroidVersion(id: subItem['id'], title: subItem['title']));
        }
      } else if (item is Map) {
        item.forEach((key, value) {
          versions.add(AndroidVersion(id: value['id'], title: value['title']));
        });
      }
    }

    setState(() {
      parsedData = versions;
    });
  }
}

class AndroidVersion {
  AndroidVersion({
    this.id,
    this.title,
  });

  int? id;
  String? title;
}
