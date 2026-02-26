import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import 'package:ledgerly_v3/core/services/analytics_service.dart';

/// Main Home Screen - Dashboard
///
/// Features:
/// - Displays user summary
/// - Shows sales and expense data
/// - Navigation to other features
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    Analytics.instance.logEvent('screen_view', {'screen': 'main'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          Analytics.instance.logEvent('nav_changed', {'index': index});
          setState(() => _currentNavIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: AppColors.primaryTeal,
        unselectedItemColor: AppColors.textGrey,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_outlined),
            activeIcon: Icon(Icons.trending_up),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_outlined),
            activeIcon: Icon(Icons.receipt),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentNavIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return _buildSalesPage();
      case 2:
        return _buildExpensesPage();
      case 3:
        return _buildProfilePage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Welcome Back!',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryTeal,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Monitor your business performance',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textGrey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            // Dashboard content placeholder
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Dashboard Content\n(To be implemented)',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: AppColors.textGrey,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesPage() {
    return SafeArea(
      child: Center(
        child: Text(
          'Sales Page',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryTeal,
          ),
        ),
      ),
    );
  }

  Widget _buildExpensesPage() {
    return SafeArea(
      child: Center(
        child: Text(
          'Expenses Page',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryTeal,
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePage() {
    return SafeArea(
      child: Center(
        child: Text(
          'Profile Page',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryTeal,
          ),
        ),
      ),
    );
  }
}
