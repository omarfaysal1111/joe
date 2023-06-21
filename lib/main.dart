import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  runApp(const MyApp());
  if (!kIsWeb) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          projectId: 'eye-can-60b59',
          appId: '1:576298614511:android:baf17afb6f77e85ed6251a',
          apiKey: 'AIzaSyD6BygTkHMNmJWLNIzvufn9x1Ar6B_gqyE',
          messagingSenderId: '576298614511',
          storageBucket: 'eye-can-60b59.appspot.com',
          authDomain: 'eye-can-60b59.firebaseapp.com'),
    );
  }
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      if (kDebugMode) {
        print('User is currently signed out!');
      }
    } else {}
  });
}

final phoneTextField = TextEditingController();
String? location;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: [
              MaterialButton(
                color: Colors.grey,
                onPressed: () async {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: "omarfaysal44@gmail.com",
                            password: "12345678");
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      // print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      // print('Wrong password provided for that user.');
                    }
                  }

                  final users = FirebaseFirestore.instance.collection('Blind');

                  Map<String, dynamic> data = {
                    "email": "yousef@gmail.com",
                    "name": "yousef",
                    "location": "mansoura",
                    "phone": "0100216776",
                    "password": "",
                    "blind_phone": "01002164859"
                  };

                  users.add(data).then((value) => print("yes")).catchError(
                      (error) => print("Failed to add user: $error"));
                },
                child: const Text("add Blind"),
              ),
              TextFormField(
                style: const TextStyle(fontStyle: FontStyle.normal),
                controller: phoneTextField,
                enableSuggestions: true,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Blind phone',
                  labelText: 'Blind phone',
                ),
              ),
              MaterialButton(
                color: Colors.grey,
                onPressed: () async {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: "omarfaysal44@gmail.com",
                            password: "12345678");
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                     
                    } else if (e.code == 'wrong-password') {
                     
                    }
                  }
                  FirebaseFirestore.instance
                      .collection('Blind')
                      .where('phone', isEqualTo: phoneTextField.text)
                      .get()
                      .then((snapshot) {
                    setState(() {
                      location = snapshot.docs[0]['location'];
                    });
                    var long =
                        location!.split('[')[1].split(']')[0].split(',')[0];
                        var lat =
                        location!.split('[')[1].split(']')[0].split(',')[1];
                    GeoPoint geoPoint = GeoPoint(double.parse(long), double.parse(lat));

                     final users = FirebaseFirestore.instance.collection('Blind');

                  Map<String, dynamic> data = {
                    "email": "omar@gmail.com",
                    "name": "omar",
                    "location": "$location",
                    "phone": "0100216776",
                    "password": "",
                    "blind_phone": phoneTextField.text
                  };

                  users.add(data).then((value) => print("yes")).catchError(
                      (error) => print("Failed to add user: $error"));
                  });
                },
                child: const Text("add Blind"),
              ),
              Text(location.toString())
            ],
          ),
        ));
  }
  //33.45343543 N
  //34.43534545 E
}
