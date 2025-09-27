import 'package:flutter/material.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LivingSeedMediaRouter.instance;
  NotificationDropDownServices.initNotificationsDropDown();
  runApp(const LivingSeedMedia());
}

class LivingSeedMedia extends StatefulWidget {
  const LivingSeedMedia({super.key});

  @override
  State<LivingSeedMedia> createState() => _LivingSeedMediaState();
}

class _LivingSeedMediaState extends State<LivingSeedMedia> {
  late DarkThemeProvider themeChangeProvider;
  late UsersAuthProvider usersAuthProvider;
  late NotificationProvider notificationProvider;
  late BookProvider aboutBookProvider;
  late BibleStudyProvider bibleStudyProvider;
  late AddEventProvider addEventProvider;
  late MagazineProvider magazineProvider;
  late JournalProvider journalProvider;

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
    journalProvider = JournalProvider();

    // Load necessary data AFTER the first frame to avoid context-related issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      usersAuthProvider.initializeUsers();
      notificationProvider.initializeNotifications();
      aboutBookProvider.initializeBooks();
      bibleStudyProvider.initializeBibleStudy();
      addEventProvider.initializeEvents();
      magazineProvider.initializeMagazines();
      journalProvider.initializeJournalPosts();
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
        ChangeNotifierProvider(create: (_) => journalProvider),
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
