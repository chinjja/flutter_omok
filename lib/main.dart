import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_omok/src/omok/view/omok_view.dart';
import 'package:flutter_omok/src/repo/omok_repo.dart';

void main() {
  runApp(RepositoryProvider(
    create: (context) => OmokRepo(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Omok Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const OmokPage(),
    );
  }
}
