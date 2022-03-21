import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reni_jaya_inventory/models/user_model.dart';
import 'package:reni_jaya_inventory/notifiers/item_notifier.dart';
import 'package:reni_jaya_inventory/services/auth.dart';
import 'package:reni_jaya_inventory/views/wrapper_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
        ChangeNotifierProvider<ItemNotifier>(create: (_) => ItemNotifier(),)
      ],
      child: const MaterialApp(
        home: WrapperView(),
      ),
    );
  }
}
