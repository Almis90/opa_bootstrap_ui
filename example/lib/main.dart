import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: BsColors.blue,
      builder: (context, child) => DefaultTextStyle(
        style: const TextStyle(color: BsColors.gray900, fontFamily: 'Roboto'),
        child: child!,
      ),
      home: const HomePage(),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      ),
    );
  }
}
