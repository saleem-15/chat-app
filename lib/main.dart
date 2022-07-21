// ignore_for_file: depend_on_referenced_packages

import 'package:chat_app/dao/dao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_view/flutter_file_view.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'controllers/controller.dart';
import 'models/chat.dart';
import 'screens/auth_screen.dart';
import 'screens/user_chats.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ChatAdapter());

  Dao.chatsBox = await Hive.openBox<Chat>('box');
  Dao.myBox = await Hive.openBox('chats');

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //make status bar color transparent
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    Get.put(Controller());

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
          if (snapshot.hasData) {
            return // const ChatScreen(chatId: 'U1kTcWfE36fMFVnWxzVW');
                const UserChats();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserChats();
  }
}
