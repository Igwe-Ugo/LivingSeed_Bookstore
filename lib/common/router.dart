import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/account/widget.dart';
import 'package:livingseed_media/admin/manage_journal.dart';
import 'package:livingseed_media/admin/widget.dart';
import 'package:livingseed_media/auth/widget.dart';
import 'package:livingseed_media/home/widget.dart';
import 'package:livingseed_media/library/widget.dart';
import 'package:livingseed_media/media/media.dart';
import 'package:livingseed_media/media/widget.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/notification/widget.dart';
import 'widget.dart';

class LivingSeedMediaRouter {
  static final LivingSeedMediaRouter _instance =
      LivingSeedMediaRouter._internal();
  static LivingSeedMediaRouter get instance => _instance;
  static late final GoRouter router;
  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> homeTabNavigationKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> libraryTabNavigationKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> mediaTabNavigationKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> notificationTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> accountTabNavigationKey =
      GlobalKey<NavigatorState>();
  BuildContext get context =>
      router.routerDelegate.navigatorKey.currentContext!;
  GoRouterDelegate get routerDelegate => router.routerDelegate;
  GoRouteInformationParser get routeInformationParser =>
      router.routeInformationParser;

  factory LivingSeedMediaRouter() {
    return _instance;
  }

  // auth pages
  static const String splashscreenPath = '/splash_screen';
  static const String landingPagePath = '/landing_page';
  static const String signinPath = '/signin';
  static const String signupPath = '/signup';
  static const String forgotPasswordPath = '/forgot_password';
  static const String signupVerificationPath = 'signup_verification';

  // home pages
  static const String homePath = '/home';
  static const String journalPath = 'journal';
  static const String journalDetailsPath = 'journal_details';

  // books pages
  static const String libraryPath = '/library';
  static const String aboutBookPath = 'about_book';
  static const String reviewsPath = 'reviews';
  static const String moreBooksPath = 'more_books';
  static const String moreBibleStudyPath = 'more_bible_study';
  static const String aboutBibleStudyPath = 'about_bible_study';
  static const String aboutMagazinePath = 'about_magazine';
  static const String moreMagazinePath = 'more_magazine';

  // media pages
  static const String mediaPath = '/media';
  static const String audioScreenPath = 'audio';

  // account pages
  static const String accountPath = '/account';
  static const String editAccountPath = 'edit_account';
  static const String cartPath = 'cart';
  static const String changePasswordPath = 'change_password';
  static const String writeReviewPath = 'write_review';
  static const String profilePath = 'profile';
  static const String booksPurchasedPath = 'book_purchased';
  static const String readBookPath = 'read_book';
  static const String upcomingEventsPath = 'upcoming_events';
  static const String viewUpcomingEventsPath = 'view_upcoming_events';

  // transaction histories
  static const String transactionHistoryPath = 'transaction_history';
  static const String receiptPath = 'receipt';

  // notification pages
  static const String notificationPath = '/notifications';
  static const String anouncementsPath = 'announcements';

  //admin pages
  static const String uploadBookPath = 'upload_book';
  static const String uploadBibleStudyPath = 'upload_bibilestudy';
  static const String uploadMagazinePath = 'upload_magazine';
  static const String dashboardPath = 'dashboard';
  static const String manageNotificationsPath = 'manage_notifications';
  static const String manageUsersPath = 'manage_users';
  static const String userProfilePath = 'user_profile';
  static const String addEventPath = 'add_event';
  static const String addArticlePath = 'add_article';
  static const String manageBooksPath = 'manage_book';
  static const String editBookPath = 'edit_book';
  static const String manageJournalPath = 'manage_journal';
  static const String editJournalPath = 'edit_journal';
  static const String manageBibleStudyPath = 'manage_biblestudy';
  static const String editBibleStudyPath = 'edit_biblestudy';
  static const String manageMagazinePath = 'manage_magazine';
  static const String editMagazinePath = 'edit_magazine';

  LivingSeedMediaRouter._internal() {
    final routes = <RouteBase>[
      GoRoute(
        path: splashscreenPath,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: landingPagePath,
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: signinPath,
        builder: (context, state) => const SignIn(),
      ),
      GoRoute(
          path: signupPath,
          builder: (context, state) => const SignUp(),
          routes: [
            GoRoute(
              path: signupVerificationPath,
              builder: (context, state) {
                final args = (state.extra as Map<String, dynamic>?) ?? {};
                return SignupVerification(
                  fullname: args['fullname'] as String? ?? '',
                  email: args['email'] as String? ?? '',
                );
              },
            ),
          ]),
      GoRoute(
        path: forgotPasswordPath,
        builder: (context, state) => const ForgotPassword(),
      ),
      StatefulShellRoute.indexedStack(
          parentNavigatorKey: parentNavigatorKey,
          builder: (context, state, navigationShell) {
            return LivingSeedNavBar(navigationShell: navigationShell);
          },
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
                navigatorKey: homeTabNavigationKey,
                routes: <RouteBase>[
                  GoRoute(
                      path: homePath,
                      builder: (context, state) => Home(),
                      routes: [
                        GoRoute(
                            path: journalPath,
                            builder: (context, state) =>
                                const JournalListScreen(),
                            routes: [
                              GoRoute(
                                path: journalDetailsPath,
                                builder: (context, state) {
                                  final journalPost =
                                      state.extra as JournalPost?;
                                  if (journalPost != null) {
                                    return JournalDetailScreen(
                                        post: journalPost);
                                  } else {
                                    return const Center(
                                        child:
                                            Text("No journal data available"));
                                  }
                                },
                              ),
                            ]),
                      ]),
                ]),
            StatefulShellBranch(
                navigatorKey: libraryTabNavigationKey,
                routes: <RouteBase>[
                  GoRoute(
                      path: libraryPath,
                      builder: (context, state) => const Library(),
                      routes: [
                        GoRoute(
                          path: moreBooksPath,
                          builder: (context, state) => const MoreBooks(),
                        ),
                        GoRoute(
                          path: moreBibleStudyPath,
                          builder: (context, state) => const MoreBibleStudy(),
                        ),
                        GoRoute(
                          path: moreMagazinePath,
                          builder: (context, state) => const MoreMagazine(),
                        ),
                        GoRoute(
                          path: aboutBibleStudyPath,
                          builder: (context, state) {
                            final aboutBibleStudy =
                                state.extra as BibleStudyMaterial?;
                            if (aboutBibleStudy != null) {
                              return AboutBibleStudy(
                                aboutBiblestudy: aboutBibleStudy,
                              );
                            } else {
                              return const Center(
                                  child: Text("No Bible Study data available"));
                            }
                          },
                        ),
                        GoRoute(
                          path: aboutBookPath,
                          builder: (context, state) {
                            final aboutBooks = state.extra as AboutBooks?;
                            if (aboutBooks != null) {
                              return AboutBook(
                                aboutBooks: aboutBooks,
                              );
                            } else {
                              return const Center(
                                  child: Text("No book data available"));
                            }
                          },
                        ),
                        GoRoute(
                          path: aboutMagazinePath,
                          builder: (context, state) {
                            final aboutMagazines =
                                state.extra as MagazineModel?;
                            if (aboutMagazines != null) {
                              return AboutMagazine(
                                magazine: aboutMagazines,
                              );
                            } else {
                              return const Center(
                                  child: Text("No book data available"));
                            }
                          },
                        ),
                      ]),
                ]),
            StatefulShellBranch(
                navigatorKey: mediaTabNavigationKey,
                routes: <RouteBase>[
                  GoRoute(
                      path: mediaPath,
                      builder: (context, state) => MediaPage(),
                      routes: [
                        GoRoute(
                          path: audioScreenPath,
                          builder: (context, state) {
                            final audio = state.extra as AudioMessage?;
                            if (audio != null) {
                              return AudioScreen(audioSongs: audio);
                            } else {
                              return const Center(
                                  child: Text("No audio data available"));
                            }
                          },
                        ),
                      ]),
                ]),
            StatefulShellBranch(
                navigatorKey: notificationTabNavigatorKey,
                routes: <RouteBase>[
                  GoRoute(
                      path: notificationPath,
                      builder: (context, state) => Notifications(),
                      routes: [
                        GoRoute(
                          path: anouncementsPath,
                          builder: (context, state) {
                            final anouncement = state.extra;
                            if (anouncement is NotificationItems) {
                              return Announcements(
                                announcement: anouncement,
                              );
                            } else {
                              return Center(
                                child: Text(
                                    'No Recent Announcements to be reviewed'),
                              );
                            }
                          },
                        ),
                      ]),
                ]),
            StatefulShellBranch(
                navigatorKey: accountTabNavigationKey,
                routes: <RouteBase>[
                  GoRoute(
                      path: accountPath,
                      builder: (context, state) => const Account(),
                      routes: [
                        // books purchased
                        GoRoute(
                            path: booksPurchasedPath,
                            builder: (context, state) => BookPurchased(),
                            routes: [
                              GoRoute(
                                  path: writeReviewPath,
                                  builder: (context, state) {
                                    final bookPurchased = state.extra;
                                    if (bookPurchased is PurchasedBooksItems) {
                                      return WriteReview(
                                        bookPurchased: bookPurchased,
                                      );
                                    } else {
                                      return Center(
                                        child: Text('Books cannot be reviewed'),
                                      );
                                    }
                                  }),
                            ]),

                        // transaction history
                        GoRoute(
                            path: transactionHistoryPath,
                            builder: (context, state) =>
                                TransactionHistoryList(),
                            routes: [
                              GoRoute(
                                  path: receiptPath,
                                  builder: (context, state) => Receipt())
                            ]),
                        // admin panel
                        GoRoute(
                            path: dashboardPath,
                            builder: (context, state) => const AdminDashboard(),
                            routes: [
                              GoRoute(
                                  path: manageBooksPath,
                                  builder: (context, state) =>
                                      const ManageBook(),
                                  routes: [
                                    GoRoute(
                                      path: editBookPath,
                                      builder: (context, state) {
                                        final aboutBooks =
                                            state.extra as AboutBooks?;
                                        if (aboutBooks != null) {
                                          return EditBook(
                                            aboutBooks: aboutBooks,
                                          );
                                        } else {
                                          return const Center(
                                              child: Text(
                                                  "No book data available to edit"));
                                        }
                                      },
                                    )
                                  ]),
                              GoRoute(
                                  path: manageBibleStudyPath,
                                  builder: (context, state) =>
                                      const BiblestudyManagement(),
                                  routes: [
                                    GoRoute(
                                      path: editBibleStudyPath,
                                      builder: (context, state) {
                                        final bibleStudy =
                                            state.extra as BibleStudyMaterial?;
                                        if (bibleStudy != null) {
                                          return EditBiblestudy(
                                            bibleStudy: bibleStudy,
                                          );
                                        } else {
                                          return const Center(
                                              child: Text(
                                                  "No bible study data available to edit"));
                                        }
                                      },
                                    )
                                  ]),
                              GoRoute(
                                  path: manageMagazinePath,
                                  builder: (context, state) =>
                                      const ManageMagazine(),
                                  routes: [
                                    GoRoute(
                                      path: editMagazinePath,
                                      builder: (context, state) {
                                        final magazine =
                                            state.extra as MagazineModel?;
                                        if (magazine != null) {
                                          return EditMagazine(
                                            magazine: magazine,
                                          );
                                        } else {
                                          return const Center(
                                              child: Text(
                                                  "No magazine data available to edit"));
                                        }
                                      },
                                    )
                                  ]),
                              GoRoute(
                                path: uploadBookPath,
                                builder: (context, state) =>
                                    const UploadBookScreen(),
                              ),
                              GoRoute(
                                path: uploadBibleStudyPath,
                                builder: (context, state) =>
                                    const UploadBibleStudy(),
                              ),
                              GoRoute(
                                path: uploadMagazinePath,
                                builder: (context, state) =>
                                    const UploadMagazineScreen(),
                              ),
                              GoRoute(
                                path: addEventPath,
                                builder: (context, state) =>
                                    const AdminAddEvent(),
                              ),
                              GoRoute(
                                path: addArticlePath,
                                builder: (context, state) =>
                                    const WriteJournal(),
                              ),
                              GoRoute(
                                  path: manageNotificationsPath,
                                  builder: (context, state) =>
                                      const AdminNotifications(),
                                  routes: [
                                    GoRoute(
                                      path: anouncementsPath,
                                      builder: (context, state) {
                                        final anouncement = state.extra;
                                        if (anouncement is NotificationItems) {
                                          return Announcements(
                                            announcement: anouncement,
                                          );
                                        } else {
                                          return Center(
                                            child: Text(
                                                'No Recent Announcements to be reviewed'),
                                          );
                                        }
                                      },
                                    ),
                                  ]),
                              GoRoute(
                                  path: manageUsersPath,
                                  builder: (context, state) =>
                                      const AdminUserManagement(),
                                  routes: [
                                    GoRoute(
                                      path: userProfilePath,
                                      builder: (context, state) {
                                        final user = state.extra;
                                        if (user is Users) {
                                          return UsersProfile(user: user);
                                        } else {
                                          return Center(
                                            child: Text(
                                                'User Profile not available'),
                                          );
                                        }
                                      },
                                    ),
                                  ]),
                              GoRoute(
                                  path: manageJournalPath,
                                  builder: (context, state) =>
                                      const JournalManagement(),
                                  routes: [
                                    GoRoute(
                                      path: editJournalPath,
                                      builder: (context, state) {
                                        final journal =
                                            state.extra as JournalPost?;
                                        if (journal != null) {
                                          return EditJournal(
                                            journals: journal,
                                          );
                                        } else {
                                          return const Center(
                                              child: Text(
                                                  "No journal data available to edit"));
                                        }
                                      },
                                    )
                                  ]),
                            ]),
                        GoRoute(
                            path: upcomingEventsPath,
                            builder: (context, state) => const UpcomingEvents(),
                            routes: [
                              GoRoute(
                                  path: viewUpcomingEventsPath,
                                  builder: (context, state) {
                                    final upcomingEvents = state.extra;
                                    if (upcomingEvents is UpcomingEventsModel) {
                                      return ViewUpcomingEvents(
                                          upcomingEvents: upcomingEvents);
                                    } else {
                                      return Center(
                                        child: Text(
                                            'Upcoming event details cannot be displayed'),
                                      );
                                    }
                                  }),
                            ]),
                        GoRoute(
                          path: cartPath,
                          builder: (context, state) {
                            final user = state.extra;
                            if (user is Users) {
                              return Cart(
                                user: user,
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25, horizontal: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              GoRouter.of(context).pop();
                                            },
                                            icon: const Icon(
                                              Iconsax.arrow_left_2,
                                              size: 17,
                                            )),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        const Text(
                                          'My Cart',
                                          style: TextStyle(
                                            fontFamily: 'Playfair',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: const [
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Icon(
                                            Icons.shopify_sharp,
                                            size: 100,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'Nothing in Cart Session yet, please add book to cart',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ]),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                        GoRoute(
                          path: editAccountPath,
                          builder: (context, state) => const Profile(),
                        ),
                        GoRoute(
                          path: changePasswordPath,
                          builder: (context, state) => const ChangePassword(),
                        ),
                        GoRoute(
                          path: profilePath,
                          builder: (context, state) => const Profile(),
                        )
                      ]),
                ]),
          ])
    ];

    router = GoRouter(
      navigatorKey: parentNavigatorKey,
      initialLocation: splashscreenPath,
      routes: routes,
    );
  }
}
