import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_providers.dart';
import 'features/home/view/home_page.dart';
import 'main_page.dart';

void main() {
  runApp(const MySiviChatApp());
}

class MySiviChatApp extends StatelessWidget {
  const MySiviChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: buildBlocProviders(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mini Chat',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const MainPage(),
      ),
    );
  }
}
