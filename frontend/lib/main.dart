import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ledgerly_v3/features/auth/screens/splash_screen.dart';
import 'package:ledgerly_v3/features/auth/login_screen.dart';
import 'package:ledgerly_v3/features/auth/screens/sign_up_screen.dart';
import 'package:ledgerly_v3/features/home/screens/main_screen.dart';
import 'package:ledgerly_v3/features/business/screens/business_screen.dart';
import 'package:ledgerly_v3/features/business/screens/business_intro.dart';
import 'package:ledgerly_v3/features/products/screens/products_screen.dart';
import 'package:ledgerly_v3/features/products/screens/add_product_screen.dart';
import 'package:ledgerly_v3/features/products/screens/products_catalogue.dart';
import 'package:ledgerly_v3/features/products/screens/products_intro_screen.dart';
import 'package:ledgerly_v3/features/sales/screens/sales_screen.dart';
import 'package:ledgerly_v3/features/sales/screens/add_sale_screen.dart';
import 'package:ledgerly_v3/features/sales/screens/sales_catalogue.dart';
import 'package:ledgerly_v3/features/expenses/screens/expenses_screen.dart';
import 'package:ledgerly_v3/features/expenses/screens/expenses_catalogue.dart';
import 'package:ledgerly_v3/features/insights/screens/insights_screen.dart';
import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/product_provider.dart';
import 'core/providers/expense_provider.dart';

void main() async {
  // Required to ensure plugin services (like SharedPreferences) are initialized
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const LedgerlyApp());
}

class LedgerlyApp extends StatelessWidget {
  const LedgerlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
      ],
      child: MaterialApp(
        title: 'Ledgerly v3',
        debugShowCheckedModeBanner: false,

        // Theming based on your Figma "Primary Teal" and clean typography
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryTeal,
            primary: AppColors.primaryTeal,
          ),
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
        ),

        // Named routes for navigation flow
        routes: {
          '/': (ctx) => const SplashScreen(),
          '/login': (ctx) => const LoginScreen(),
          '/register': (ctx) => const SignupScreen(),
          '/dashboard': (ctx) => const MainScreen(),

          // Onboarding / business
          '/business-intro': (ctx) => const BusinessIntroScreen(),
          '/business': (ctx) => const BusinessScreen(),

          // Products
          '/products-intro': (ctx) => const ProductsIntroScreen(),
          '/products': (ctx) => const AddProductFormScreen(),
          '/products/add': (ctx) => const ProductAddedScreen(),
          '/products/catalogue': (ctx) => const ProductsCatalogueScreen(),

          // Sales
          '/sales': (ctx) => const SalesScreen(),
          '/sales/add': (ctx) => const AddSaleScreen(),
          '/sales/catalogue': (ctx) => const SalesCatalogueScreen(),

          // Expenses
          '/expenses': (ctx) => const ExpensesScreen(),
          '/expenses/catalogue': (ctx) => const ExpensesCatalogueScreen(),

          // Insights
          '/home': (ctx) => const HomeScreen(),
        },

        initialRoute: '/',
      ),
    );
  }
}

// Backwards-compatible alias expected by some tests/examples
class MyApp extends LedgerlyApp {
  const MyApp({super.key});
}
