import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/part_item.dart';
import 'providers/parts_provider.dart';
import 'screens/parts_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PartCategoryAdapter());
  Hive.registerAdapter(PartItemAdapter());
  final partsBox = await Hive.openBox<PartItem>('parts');
  runApp(MyApp(partsBox: partsBox));
}

class MyApp extends StatelessWidget {
  final Box<PartItem> partsBox;
  const MyApp({super.key, required this.partsBox});

  @override
  Widget build(BuildContext context) {
    final ThemeData darkBase = FlexThemeData.dark(
      scheme: FlexScheme.ebonyClay,
      useMaterial3: true,
      subThemesData: const FlexSubThemesData(defaultRadius: 12),
      visualDensity: VisualDensity.comfortable,
    );
    final ThemeData darkTheme = darkBase.copyWith(
      textTheme: GoogleFonts.interTextTheme(darkBase.textTheme),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PartsProvider(partsBox)),
      ],
      child: MaterialApp(
        title: 'Планувальник автозапчастин',
        themeMode: ThemeMode.dark,
        darkTheme: darkTheme,
        home: const PartsListScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
