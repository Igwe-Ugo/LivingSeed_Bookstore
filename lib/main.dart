import 'package:flutter/material.dart';
import 'package:livingseed_bookstore/common/widget.dart';
import 'package:livingseed_bookstore/services/widget.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LivingSeedMediaRouter.instance;
  runApp(const LivingSeedBookStoreApp());
}

class LivingSeedBookStoreApp extends StatefulWidget {
  const LivingSeedBookStoreApp({super.key});

  @override
  State<LivingSeedBookStoreApp> createState() => _LivingSeedBookStoreAppState();
}

class _LivingSeedBookStoreAppState extends State<LivingSeedBookStoreApp> {
  late DarkThemeProvider themeChangeProvider;
  late UsersAuthProvider usersAuthProvider;
  late NotificationProvider notificationProvider;
  late BookProvider aboutBookProvider;
  late BibleStudyProvider bibleStudyProvider;
  late AddEventProvider addEventProvider;
  late MagazineProvider magazineProvider;

  @override
  void initState() {
    super.initState();

    themeChangeProvider = DarkThemeProvider();
    usersAuthProvider = UsersAuthProvider();
    notificationProvider = NotificationProvider();
    aboutBookProvider = BookProvider();
    bibleStudyProvider = BibleStudyProvider();
    addEventProvider = AddEventProvider();
    magazineProvider = MagazineProvider();

    // Load necessary data AFTER the first frame to avoid context-related issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      usersAuthProvider.initializeUsers();
      notificationProvider.initializeNotifications();
      aboutBookProvider.initializeBooks();
      bibleStudyProvider.initializeBibleStudy();
      addEventProvider.initializeEvents();
      magazineProvider.initializeMagazines();
    });

    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.livingSeedPreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeChangeProvider),
        ChangeNotifierProvider(create: (_) => usersAuthProvider),
        ChangeNotifierProvider(create: (_) => notificationProvider),
        ChangeNotifierProvider(create: (_) => aboutBookProvider),
        ChangeNotifierProvider(create: (_) => bibleStudyProvider),
        ChangeNotifierProvider(create: (_) => addEventProvider),
        ChangeNotifierProvider(create: (_) => magazineProvider),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (context, themeData, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Living Seed Media',
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            routerConfig: LivingSeedMediaRouter.router,
          );
        },
      ),
    );
  }
}
