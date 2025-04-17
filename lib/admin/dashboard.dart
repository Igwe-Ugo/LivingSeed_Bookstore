import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_bookstore/common/router.dart';
import 'package:livingseed_bookstore/services/widget.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<MagazineProvider, BibleStudyProvider, BookProvider>(
        builder: (context, magazineProvider, bibleStudyProvider, bookProvider,
            child) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Admin Dashboard',
                    style: TextStyle(
                      fontFamily: 'Playfair',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              // Dashboard Overview
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDashboardCard(context, 'Books', Iconsax.book,
                      Colors.blue, bookProvider.allBooks.length),
                  _buildDashboardCard(context, 'Bible Study', Iconsax.book_1,
                      Colors.green, bibleStudyProvider.allBibleStudies.length),
                  _buildDashboardCard(context, 'Magazines', Iconsax.book_saved,
                      Colors.orange, magazineProvider.magazines.length),
                ],
              ),
              const SizedBox(height: 20),

              // Action Buttons
              const Text(
                'Actions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        style: ButtonStyle(
                          elevation: WidgetStatePropertyAll(0),
                        ),
                        onPressed: () => GoRouter.of(context).go(
                            '${LivingSeedBookStoreRouter.accountPath}/${LivingSeedBookStoreRouter.dashboardPath}/${LivingSeedBookStoreRouter.uploadBookPath}'),
                        icon: const Icon(Iconsax.document_upload),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: const Text('Upload Book'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        style: ButtonStyle(
                          elevation: WidgetStatePropertyAll(0),
                        ),
                        onPressed: () => GoRouter.of(context).go(
                            '${LivingSeedBookStoreRouter.accountPath}/${LivingSeedBookStoreRouter.dashboardPath}/${LivingSeedBookStoreRouter.uploadBibleStudyPath}'),
                        icon: const Icon(Iconsax.document_cloud),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: const Text('Upload Bible study material'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        style: ButtonStyle(
                          elevation: WidgetStatePropertyAll(0),
                        ),
                        onPressed: () {},
                        /* GoRouter.of(context).go(
                            '${LivingSeedBookStoreRouter.accountPath}/${LivingSeedBookStoreRouter.dashboardPath}/${LivingSeedBookStoreRouter.uploadBibleStudyPath}'), */
                        icon: const Icon(Iconsax.document_code),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: const Text('Upload Magazine'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        style:
                            ButtonStyle(elevation: WidgetStatePropertyAll(0)),
                        onPressed: () => GoRouter.of(context).go(
                            '${LivingSeedBookStoreRouter.accountPath}/${LivingSeedBookStoreRouter.dashboardPath}/${LivingSeedBookStoreRouter.manageNotificationsPath}'),
                        icon: const Icon(Iconsax.notification),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: const Text('Manage Notifications'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        style:
                            ButtonStyle(elevation: WidgetStatePropertyAll(0)),
                        onPressed: () => GoRouter.of(context).go(
                            '${LivingSeedBookStoreRouter.accountPath}/${LivingSeedBookStoreRouter.dashboardPath}/${LivingSeedBookStoreRouter.manageUsersPath}'),
                        icon: const Icon(Iconsax.people),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: const Text('Manage Users'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        style:
                            ButtonStyle(elevation: WidgetStatePropertyAll(0)),
                        onPressed: () => GoRouter.of(context).go(
                            '${LivingSeedBookStoreRouter.accountPath}/${LivingSeedBookStoreRouter.dashboardPath}/${LivingSeedBookStoreRouter.addEventPath}'),
                        icon: const Icon(Iconsax.calendar),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: const Text('Add Upcoming Event'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Recent Activities Section
              const Text(
                'Recent Activities',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(
                        index % 3 == 0
                            ? Iconsax.book
                            : index % 3 == 1
                                ? Iconsax.book_1
                                : Iconsax.book_saved,
                        color: Colors.grey[700],
                      ),
                      title: Text('Activity ${index + 1}'),
                      subtitle: Text(
                        index % 3 == 0
                            ? 'Uploaded a book'
                            : index % 3 == 1
                                ? 'Uploaded a Bible study material'
                                : 'Uploaded a Magazine',
                      ),
                      trailing: Text(
                        '${DateTime.now().subtract(Duration(days: index)).toLocal()}'
                            .split(' ')[0],
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDashboardCard(BuildContext context, String title, IconData icon,
      Color color, int count) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
        height: 150,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 10),
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
