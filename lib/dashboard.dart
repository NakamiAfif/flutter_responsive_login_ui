import 'package:flutter/material.dart';
import 'package:flutter_responsive_login_ui/widgets/dashboard_item.dart';
import 'package:flutter_responsive_login_ui/widgets/notification_badge.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // TODO: Implement notification handling
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DashboardItem(
                  icon: Icons.list,
                  title: 'Item Listing',
                  onTap: () {
                    // TODO: Implement item listing screen navigation
                  },
                ),
                DashboardItem(
                  icon: Icons.search,
                  title: 'Search',
                  onTap: () {
                    // TODO: Implement search screen navigation
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DashboardItem(
                  icon: Icons.message,
                  title: 'Messaging',
                  onTap: () {
                    // TODO: Implement messaging screen navigation
                  },
                ),
                DashboardItem(
                  icon: Icons.star,
                  title: 'Rating and Reviews',
                  onTap: () {
                    // TODO: Implement rating and reviews screen navigation
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
