import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  DatabaseReference ref = FirebaseDatabase.instance.ref("users/123");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("fro initial state${ref}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
                onPressed: () async {
                  await ref.set({
                    "name": "John$index",
                    "age": 18,
                    "address": {"line1": "100 Mountain View"}
                  });
                  index += 1;
                  print("done");
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: StreamBuilder(
          stream: ref.onValue,
          builder:
              (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {

            if (snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              print("=====${snapshot.data!.snapshot.value}");
              return Center(
                child: ListView.builder(
                    itemCount: snapshot.data?.snapshot.children.length,
                    itemBuilder: (ctx, i) => Text(
                          "${snapshot.data?.snapshot.value!}",
                          style: const TextStyle(fontSize: 40),
                        )),
              );
            }
          },
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
