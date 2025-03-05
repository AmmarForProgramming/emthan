import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import '../purchases/purchases_screen.dart';
import '../sales/sales_screen.dart';
import '../../providers/notification_provider.dart';
//import '../inventory/inventory_screen.dart';
import '../products_screen.dart';
import '../../screens/profile_screen.dart';
import '../settings/settings_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../screens/notifications_screen.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentBottomIndex = 0;

  final List<Widget> _bottomPages = [
    const HomeContent(),
    const SettingsPage(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading:Builder(builder: (context)=>IconButton(
          icon: Icon(Icons.menu , color: const Color.fromARGB(255, 5, 3, 134)),
          onPressed: (){Scaffold.of(context).openDrawer();
          },
          ),
        ),
        title:  Text(_getTitle(_currentBottomIndex)),
        actions: [
 _buildNotificationIcon(),
        ],
      ),
      drawer: _buildSideMenu(context),
      body: _bottomPages[_currentBottomIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'لوحة التحكم';
      case 1:
        return 'الإعدادات';
      case 2:
        return 'الملف الشخصي';
      default:
        return 'تطبيق';
    }
  }

Widget _buildNotificationIcon() {
    return Consumer<NotificationsProvider>(
      builder: (context, notificationProvider, child) {
        int notificationCount = notificationProvider.unreadCount;
        return Stack(
          children: [
            IconButton(
              icon: Icon(Icons.notifications, color: const Color.fromARGB(255, 24, 1, 109)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationsScreen()),
                );
              },
            ),
            if (notificationCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                  child: Text(
                    '$notificationCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // القائمة الجانبية للتقارير
  Widget _buildSideMenu(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Center(
              child: Text('التقارير',
             
                ),
          ),
          ),
          _buildMenuTile(context, Icons.shopping_cart, 'تقرير المشتريات', const PurchasesPage()),
          _buildMenuTile(context, Icons.attach_money, 'تقرير المبيعات', const SalesPage()),
          _buildMenuTile(context, Icons.warehouse, 'تقرير المخازن', const ManageProductsPage()),
        ],
      ),
    );
  }

  // عنصر القائمة الجانبية
  Widget _buildMenuTile(BuildContext context, IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: 500.ms,
            pageBuilder: (_, __, ___) => page,
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        );
      },
    ).animate().fadeIn(delay: 100.ms);
  }

  // شريط التنقل السفلي
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentBottomIndex,
      onTap: (index) => setState(() => _currentBottomIndex = index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'الرئيسية',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'الإعدادات',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'الحساب',
        ),
      ],
    );
  }
}
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDashboardCard(context,'المشتريات', Icons.shopping_basket, Colors.green, const PurchasesPage()),
            _buildDashboardCard(context,'المبيعات', Icons.currency_exchange, Colors.blue, const SalesPage()),
            _buildDashboardCard(context,'المخازن', Icons.inventory, Colors.orange, const ManageProductsPage()),
          ],
        ),
      ),
    );
  }
}

 Widget _buildDashboardCard(BuildContext context, title, IconData icon, Color color, Widget page) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: (){ Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>page),
        );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(icon, size: 50, color: color),
              const SizedBox(height: 10),
              Text(title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color
                ),
                ),
            ],
          ),
        ),
      ),
    ).animate().scale(delay: 200.ms);
  }


