import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpansionTileScreen extends StatefulWidget {
  @override
  _ExpansionTileScreenState createState() => _ExpansionTileScreenState();
}

class _ExpansionTileScreenState extends State<ExpansionTileScreen> {
  List<ExpansionItem> expansionItems = [];
  TextEditingController textEditingController = TextEditingController();
  String keyDocumentPath="keyPath";

  @override
  void initState() {
    super.initState();
    loadDocumentPath();
  }


  Future<void> loadDocumentPath() async{
    final sharePrefer= await SharedPreferences.getInstance();
    final List<String>? listSavedPath= sharePrefer.getStringList(keyDocumentPath);
    if(listSavedPath!=null){
      setState(() {
        expansionItems = listSavedPath.map((path) => ExpansionItem(path, [])).toList();
      });
    }
    else{
      setState(() {
        expansionItems=[];
      });
    }
  }

  Future<void> saveDocumentPath(List<ExpansionItem> items) async{
    final sharePrefer= await SharedPreferences.getInstance();
    final List<String>? listNameDocument= items.map((e) => e.title).toList();
    await sharePrefer.setString(keyDocumentPath, listNameDocument.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents Path'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: expansionItems.length,
        itemBuilder: (context, index) {
          TextEditingController controller = TextEditingController();
          return ExpansionTile(
            title: Text(expansionItems[index].title),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Inserisci il nome del documento",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        setState(() {
                          expansionItems[index].filePaths.add(controller.text);
                          controller.clear();
                        });
                      }
                    },
                    child: const Text('Aggiungi percorso'),
                  ),
                  const SizedBox(height: 10),
                  const Text('Documenti:'),
                  Column(
                    children: expansionItems[index].filePaths.map((path) {
                      return ListTile(
                        title: Text(path),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Inserisci titolo categoria'),
                content: TextField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Titolo',
                    border: OutlineInputBorder(),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      if (textEditingController.text.isNotEmpty) {
                        setState(() {
                          expansionItems.add(ExpansionItem(textEditingController.text, []));
                          saveDocumentPath(expansionItems);
                        });
                        textEditingController.clear();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Aggiungi'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ExpansionItem {
  final String title;
  final List<String> filePaths;

  ExpansionItem(this.title, this.filePaths);
}
