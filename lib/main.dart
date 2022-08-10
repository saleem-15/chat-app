// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:chat_app/storage/dao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_view/flutter_file_view.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'controllers/controller.dart';
import 'models/chat.dart';
import 'models/message.dart';
import 'models/message_type.dart';
import 'screens/auth_screen.dart';
import 'screens/user_chats/screens/user_chats.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MessageTypeAdapter());
  Hive.registerAdapter(MessageAdapter());
  Hive.registerAdapter(ChatAdapter());

  Dao.chatsBox = await Hive.openBox<Chat>('chats');
  Dao.myBox = await Hive.openBox('box');
  // Dao.printChatBoxData();

  await Firebase.initializeApp();
  await resetApp();
  runApp(const MyApp());
}

Future<void> resetApp() async {
  await Dao.chatsBox.clear();
  await Dao.myBox.clear();
  await FirebaseAuth.instance.signOut();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //make status bar color transparent
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        ViewerLocalizationsDelegate.delegate,
      ],
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          ///
          if (snapshot.hasData) {
            final controller = Get.put(Controller());

            log('is data initialized from the back-end: ${Dao.instance.isDataInitilizedFromBackend}');
            return FutureBuilder(
              future: !Dao.instance.isDataInitilizedFromBackend
                  ? controller.intilizeDataFromBackend()
                  : controller.initilizeData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: double.infinity,
                    child: Scaffold(
                      body: Center(
                        child: Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width - 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: const [
                              Text('Loading'),
                              SizedBox(height: 20),
                              Center(child: CircularProgressIndicator()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const UserChats();
              },
            );
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
