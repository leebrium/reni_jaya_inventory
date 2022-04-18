import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reni_jaya_inventory/notifiers/user_notifier.dart';
import 'package:reni_jaya_inventory/views/authenticate/authenticate_view.dart';
import 'package:reni_jaya_inventory/views/home_view.dart';
import 'package:reni_jaya_inventory/extensions/string.dart';


class WrapperView extends StatelessWidget {
  const WrapperView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();

    if (user == null) {
      return const AuthenticateView();
    } else {
      Provider.of<UserDataNotifier>(context).setUserId(user.email!.toBase64());
      return const HomeView(
        type: HomeViewType.category,
      );
    }
  }
}
