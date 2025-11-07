// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';
import '../common/widget.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final double _fontSize = 13.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.1),
      body: Consumer2<UsersAuthProvider, DarkThemeProvider>(
          builder: (context, userProvider, themeChangeProvider, child) {
        final themeChange = themeChangeProvider;
        // Ensure userData is not null before accessing it
        if (userProvider.userData == null) {
          return const SizedBox();
        }
        Users user = userProvider.userData!;
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/LSeed-Logo-1.png',
                          scale: 5,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Account',
                          style: TextStyle(
                              fontFamily: 'Playfair',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 15),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: InkWell(
                  onTap: () => GoRouter.of(context).go(
                      '${LivingSeedRouter.accountPath}/${LivingSeedRouter.profilePath}'),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(user.userImage),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        user.fullname,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(user.emailAddress)
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Collections',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () => GoRouter.of(context).go(
                          '${LivingSeedRouter.accountPath}/${LivingSeedRouter.cartPath}',
                          extra: user),
                      leading: const Icon(Icons.shopping_cart_outlined),
                      title: Text(
                        'My Cart',
                        style: TextStyle(
                            fontSize: _fontSize, fontWeight: FontWeight.w700),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                    ),
                    ListTile(
                      onTap: () => GoRouter.of(context).go(
                        '${LivingSeedRouter.accountPath}/${LivingSeedRouter.booksPurchasedPath}',
                      ),
                      leading: const Icon(Iconsax.document_download),
                      title: Text(
                        'Books Purchased',
                        style: TextStyle(
                            fontSize: _fontSize, fontWeight: FontWeight.w700),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                    ),
                    ListTile(
                      onTap: () => GoRouter.of(context).go(
                        '${LivingSeedRouter.accountPath}/${LivingSeedRouter.transactionHistoryPath}',
                      ),
                      leading: const Icon(Icons.history_outlined),
                      title: Text(
                        'Transaction History',
                        style: TextStyle(
                            fontSize: _fontSize, fontWeight: FontWeight.w700),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                    ),
                    user != null && user.role == 'Admin'
                        ? ListTile(
                            onTap: () {
                              GoRouter.of(context).go(
                                  '${LivingSeedRouter.accountPath}/${LivingSeedRouter.dashboardPath}');
                            },
                            leading:
                                const Icon(Icons.admin_panel_settings_outlined),
                            title: Text(
                              'Admin',
                              style: TextStyle(
                                  fontSize: _fontSize,
                                  fontWeight: FontWeight.w700),
                            ),
                            trailing:
                                const Icon(Icons.keyboard_arrow_right_outlined),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Help  and support',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: const Icon(Iconsax.activity),
                      title: Text(
                        'About Livng Seed',
                        style: TextStyle(
                            fontSize: _fontSize, fontWeight: FontWeight.w700),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                    ),
                    ListTile(
                      onTap: () => GoRouter.of(context).go(
                          '${LivingSeedRouter.accountPath}/${LivingSeedRouter.upcomingEventsPath}'),
                      leading: const Icon(Iconsax.calendar),
                      title: Text(
                        'Upcoming meetings',
                        style: TextStyle(
                            fontSize: _fontSize, fontWeight: FontWeight.w700),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Settings',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Iconsax.sun_1),
                      title: Text(
                        'Dark mode',
                        style: TextStyle(
                            fontSize: _fontSize, fontWeight: FontWeight.w700),
                      ),
                      trailing: Switch(
                        activeColor: Colors.white,
                        activeTrackColor: Theme.of(context).primaryColor,
                        inactiveTrackColor: Colors.grey.withOpacity(0.3),
                        inactiveThumbColor: Colors.white,
                        value: themeChange.darkTheme,
                        trackOutlineColor: WidgetStateProperty.resolveWith(
                            (states) => Colors.transparent),
                        onChanged: (value) {
                          setState(() {
                            themeChange.darkTheme = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      onTap: () => GoRouter.of(context).go(
                          '${LivingSeedRouter.accountPath}/${LivingSeedRouter.changePasswordPath}'),
                      leading: const Icon(Iconsax.lock_1),
                      title: Text(
                        'Change Password',
                        style: TextStyle(
                            fontSize: _fontSize, fontWeight: FontWeight.w700),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(20, 40, 20, 10),
                  decoration: BoxDecoration(
                    border: BoxBorder.lerp(
                        Border.all(color: Theme.of(context).disabledColor),
                        Border.all(color: Theme.of(context).disabledColor),
                        2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () => showLogoutDialog(context),
                    child: Text('Log out',
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      }),
    );
  }
}

Future<void> showLogoutDialog(BuildContext context) {
  double _fontSize = 13.0;
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text(
        'Logging out?',
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        height: 40,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Are you sure you want to log out from your account on this device?',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Provider.of<UsersAuthProvider>(context, listen: false).signout();
            Navigator.of(context).pop();
            GoRouter.of(context).go(LivingSeedRouter.signinPath);
            showMessage('Logged Out!', context);
          },
          child: Text(
            'log out'.toUpperCase(),
            style: TextStyle(
                fontSize: _fontSize, color: Theme.of(context).primaryColor),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'not yet'.toUpperCase(),
            style: TextStyle(
                fontSize: _fontSize, color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    ),
  );
}
