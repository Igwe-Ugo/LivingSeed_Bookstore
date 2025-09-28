import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  // A list to generate the recent activities data (instead of using the builder index)
  final List<Map<String, dynamic>> _activities = const [
    {
      'title': 'Activity 1',
      'subtitle': 'Uploaded a book',
      'icon': Iconsax.book,
      'days_ago': 0
    },
    {
      'title': 'Activity 2',
      'subtitle': 'Uploaded a Bible study material',
      'icon': Iconsax.book_1,
      'days_ago': 1
    },
    {
      'title': 'Activity 3',
      'subtitle': 'Uploaded a Magazine',
      'icon': Iconsax.book_saved,
      'days_ago': 2
    },
    {
      'title': 'Activity 4',
      'subtitle': 'Uploaded a book',
      'icon': Iconsax.book,
      'days_ago': 3
    },
    {
      'title': 'Activity 5',
      'subtitle': 'Uploaded a Bible study material',
      'icon': Iconsax.book_1,
      'days_ago': 4
    },
    {
      'title': 'Activity 6',
      'subtitle': 'Uploaded a Magazine',
      'icon': Iconsax.book_saved,
      'days_ago': 5
    },
    {
      'title': 'Activity 7',
      'subtitle': 'Uploaded a book',
      'icon': Iconsax.book,
      'days_ago': 6
    },
    {
      'title': 'Activity 8',
      'subtitle': 'Uploaded a Bible study material',
      'icon': Iconsax.book_1,
      'days_ago': 7
    },
    {
      'title': 'Activity 9',
      'subtitle': 'Uploaded a Magazine',
      'icon': Iconsax.book_saved,
      'days_ago': 8
    },
    {
      'title': 'Activity 10',
      'subtitle': 'Uploaded a book',
      'icon': Iconsax.book,
      'days_ago': 9
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer3<MagazineProvider, BibleStudyProvider, BookProvider>(
        builder: (context, magazineProvider, bibleStudyProvider, bookProvider,
            child) {
      return Scaffold(
        body: SafeArea(
          // SingleChildScrollView wraps the entire body content
          child: SingleChildScrollView(
            child: Padding(
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
                      _buildDashboardCard(
                          context,
                          'Bible Study',
                          Iconsax.book_1,
                          Colors.green,
                          bibleStudyProvider.allBibleStudies.length),
                      _buildDashboardCard(
                          context,
                          'Magazines',
                          Iconsax.book_saved,
                          Colors.orange,
                          magazineProvider.magazines.length),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons - GridView (4 columns)
                  const Text(
                    'Actions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 10),

                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.9,
                    children: [
                      // Upload Book
                      _buildActionButton(
                        context,
                        title: 'Upload Book',
                        icon: Iconsax.document_upload,
                        onPressed: () => GoRouter.of(context).go(
                            '${LivingSeedMediaRouter.accountPath}/${LivingSeedMediaRouter.dashboardPath}/${LivingSeedMediaRouter.uploadBookPath}'),
                      ),
                      // Upload Bible Study
                      _buildActionButton(
                        context,
                        title: 'Upload Bible Study',
                        icon: Iconsax.document_cloud,
                        onPressed: () => GoRouter.of(context).go(
                            '${LivingSeedMediaRouter.accountPath}/${LivingSeedMediaRouter.dashboardPath}/${LivingSeedMediaRouter.uploadBibleStudyPath}'),
                      ),
                      // Upload Magazine
                      _buildActionButton(
                        context,
                        title: 'Upload Magazine',
                        icon: Iconsax.document_code,
                        onPressed: () {},
                      ),
                      // Manage Notifications
                      _buildActionButton(
                        context,
                        title: 'Manage Notifications',
                        icon: Iconsax.notification,
                        onPressed: () => GoRouter.of(context).go(
                            '${LivingSeedMediaRouter.accountPath}/${LivingSeedMediaRouter.dashboardPath}/${LivingSeedMediaRouter.manageNotificationsPath}'),
                      ),
                      // Manage Users
                      _buildActionButton(
                        context,
                        title: 'Manage Users',
                        icon: Iconsax.people,
                        onPressed: () => GoRouter.of(context).go(
                            '${LivingSeedMediaRouter.accountPath}/${LivingSeedMediaRouter.dashboardPath}/${LivingSeedMediaRouter.manageUsersPath}'),
                      ),
                      // Add Upcoming Event
                      _buildActionButton(
                        context,
                        title: 'Add Event',
                        icon: Iconsax.calendar,
                        onPressed: () => GoRouter.of(context).go(
                            '${LivingSeedMediaRouter.accountPath}/${LivingSeedMediaRouter.dashboardPath}/${LivingSeedMediaRouter.addEventPath}'),
                      ),
                      _buildActionButton(
                        context,
                        title: 'Write Article',
                        icon: Iconsax.pen_add,
                        onPressed: () {},
                      ),
                      _buildActionButton(
                        context,
                        title: 'Reports',
                        icon: Iconsax.chart_21,
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Recent Activities Section
                  const Text(
                    'Recent Activities',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // REPLACED: ListView.builder and SizedBox with a simple Column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Use a map function to generate the ListTiles directly in the Column's children
                    children: _activities.map((activity) {
                      return ListTile(
                        leading: Icon(
                          activity['icon'] as IconData,
                          color: Colors.grey[700],
                        ),
                        title: Text(activity['title'] as String),
                        subtitle: Text(activity['subtitle'] as String),
                        trailing: Text(
                          // Calculate the date string based on the 'days_ago' value
                          '${DateTime.now().subtract(Duration(days: activity['days_ago'] as int)).toLocal()}'
                              .split(' ')[0],
                          style: const TextStyle(color: Colors.grey),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // Widget for Dashboard Overview Cards (unchanged)
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

  // Widget for GridView Action Buttons (unchanged)
  Widget _buildActionButton(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onPressed}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 24, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
