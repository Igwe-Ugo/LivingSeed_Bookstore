import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // watch the activity service for real-time updates
    final activityService = Provider.of<AdminActivityService>(context);
    final recentActivities = activityService.recentActivities;

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
                children: <Widget>[
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
                                '${LivingSeedMediaRouter.accountPath}/${LivingSeedMediaRouter.dashboardPath}/${LivingSeedMediaRouter.manageBooksPath}');
                          }),
                      _buildDashboardCard(
                          context: context,
                          title: 'Bible Study',
                          icon: Iconsax.book_1,
                          color: Colors.green,
                          count: bibleStudyProvider.allBibleStudies.length,
                          onTap: () {
                            GoRouter.of(context).go(
                                '${LivingSeedMediaRouter.accountPath}/${LivingSeedMediaRouter.dashboardPath}/${LivingSeedMediaRouter.manageBibleStudyPath}');
                          }),
                      _buildDashboardCard(
                          context: context,
                          title: 'Magazines',
                          icon: Iconsax.book_saved,
                          color: Colors.orange,
                          count: magazineProvider.magazines.length,
                          onTap: () {
                            GoRouter.of(context).go(
                                '${LivingSeedMediaRouter.accountPath}/${LivingSeedMediaRouter.dashboardPath}/${LivingSeedMediaRouter.manageMagazinePath}');
                          }),
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
                        title: 'Write Journal',
                        icon: Iconsax.pen_add,
                        onPressed: () => GoRouter.of(context).go(
                            '${LivingSeedMediaRouter.accountPath}/${LivingSeedMediaRouter.dashboardPath}/${LivingSeedMediaRouter.addArticlePath}'),
                      ),
                      _buildActionButton(
                        context,
                        title: 'Edit Journal',
                        icon: Iconsax.edit_2,
                        onPressed: () => GoRouter.of(context).go(
                            '${LivingSeedMediaRouter.accountPath}/${LivingSeedMediaRouter.dashboardPath}/${LivingSeedMediaRouter.manageJournalPath}'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // --- Activity Log Section ---
                  const Text(
                    'Recent Activities (Last 20)',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  if (recentActivities.isEmpty)
                    Center(
                      child: Column(
                        children: const [
                          SizedBox(
                            height: 40,
                          ),
                          Icon(
                            Iconsax.activity,
                            size: 80,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'No Activities logged yet.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentActivities.length,
                      itemBuilder: (context, index) {
                        final activity = recentActivities[index];
                        return _buildActivityTile(context, activity);
                      },
                    ),
                  // --- End Activity Log Section ---
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
  Widget _buildActivityTile(BuildContext context, AdminActivity activity) {
    // Calculate time difference
    final difference = DateTime.now().difference(activity.timestamp);
    String timeAgo;
    if (difference.inHours < 24) {
      timeAgo = '${difference.inHours} hrs ago';
    } else {
      timeAgo = '${difference.inDays} days ago';
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        child: Icon(activity.icon,
            color: Theme.of(context).primaryColor, size: 20),
      ),
      title: Text(activity.action,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(activity.details),
      trailing: Text(
        timeAgo,
        style: const TextStyle(fontSize: 10, color: Colors.grey),
      ),
    );
  }
}
