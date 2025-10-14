import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';
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
    return Consumer4<MagazineProvider, BibleStudyProvider, BookProvider,
            UsersAuthProvider>(
        builder: (context, magazineProvider, bibleStudyProvider, bookProvider,
            userProvider, child) {
      final Users? user = userProvider.userData;
      // Safety check: Dashboard should not load if user is null,
      // but we handle it gracefully here.
      if (user == null) {
        return const Center(child: CircularProgressIndicator());
      }

      // Use the new recentActivities list, reversed for proper display order
      final List<AdminRecentActivity> activities =
          user.recentActivities!.reversed.toList();

      // Check if the current user is an Admin
      final bool isAdmin = user.role == 'Admin';
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Iconsax.arrow_left_2,
              size: 17,
            ),
          ),
          title: const Text(
            'Admin Dashboard',
            style: TextStyle(
              fontFamily: 'Playfair',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          // SingleChildScrollView wraps the entire body content
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dashboard Overview
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildDashboardCard(
                          context: context,
                          title: 'Books',
                          icon: Iconsax.book,
                          color: Colors.blue,
                          count: bookProvider.allBooks.length,
                          onTap: () {
                            GoRouter.of(context).go(
                                '${LivingSeedMediaRouter.accountPath}/${LivingSeedMediaRouter.dashboardPath}/${LivingSeedMediaRouter.manageBooks}');
                          }),
                      _buildDashboardCard(
                          context: context,
                          title: 'Bible Study',
                          icon: Iconsax.book_1,
                          color: Colors.green,
                          count: bibleStudyProvider.allBibleStudies.length,
                          onTap: () {}),
                      _buildDashboardCard(
                          context: context,
                          title: 'Magazines',
                          icon: Iconsax.book_saved,
                          color: Colors.orange,
                          count: magazineProvider.magazines.length,
                          onTap: () {}),
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
                        onPressed: () => GoRouter.of(context).go(
                            '${LivingSeedMediaRouter.accountPath}/${LivingSeedMediaRouter.dashboardPath}/${LivingSeedMediaRouter.uploadMagazinePath}'),
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
                        onPressed: () => GoRouter.of(context).go(
                            '${LivingSeedMediaRouter.accountPath}/${LivingSeedMediaRouter.dashboardPath}/${LivingSeedMediaRouter.addArticle}'),
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
  Widget _buildDashboardCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required int count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
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

  // Helper widget to display a single activity log entry
  Widget _buildActivityTile(
      BuildContext context, AdminRecentActivity activity) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        child: Icon(
            activity.title.contains('Upload')
                ? Iconsax.arrow_up_1
                : Iconsax.edit,
            color: Theme.of(context).primaryColor,
            size: 20),
      ),
      title: Text(activity.title,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(activity.subtitle),
      trailing: Text(
        '${DateTime.now().difference(activity.timestamp).inHours} hrs ago',
        style: const TextStyle(fontSize: 10, color: Colors.grey),
      ),
      onTap: () {
        // Navigate to the detailed activity page
        context.push('/admin/activity-detail', extra: activity);
      },
    );
  }
}
