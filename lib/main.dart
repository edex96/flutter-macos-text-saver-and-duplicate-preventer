import 'package:duplicatechecker/utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Box? box;

void main() async {
  await Hive.initFlutter();
  box = await Hive.openBox('v1');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<String> items = [];

  save(String val) async {
    items.add(val);
    await box?.put('items', items);
    setState(() {});
  }

  onSubmitted(String val) {
    if (items.contains(val)) {
      snack(context, 'Zaten var', negative: true);
    } else {
      snack(context, 'Eklendi');
      save(val);
    }
  }

  delete(int index) async {
    items.removeAt(index);
    await box?.put('items', items);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final data = await box?.get('items');
      if (data != null && data is Iterable) {
        setState(() {
          items = List<String>.from(data);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffebedf2),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            const Row(
              children: [
                Text(
                  'IMEI Listem',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Colors.white,
                ),
                child: items.isEmpty
                    ? const Center(
                        child: Text('Liste Boş!'),
                      )
                    : ListView.separated(
                        separatorBuilder: (context, index) {
                          return const Divider(
                              height: 2, color: Colors.black12);
                        },
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(items[index]),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () {
                                delete(index);
                              },
                            ),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Yeni imei gir',
              ),
              onSubmitted: onSubmitted,
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
