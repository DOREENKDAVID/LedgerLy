import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ledgerly_v3/features/auth/screens/splash_screen.dart';
import 'package:ledgerly_v3/features/auth/screens/login_screen.dart';
import 'package:ledgerly_v3/features/auth/screens/sign_up_screen.dart';
import 'package:ledgerly_v3/features/home/screens/main_screen.dart';
import 'package:ledgerly_v3/features/business/screens/business_screen.dart';
import 'package:ledgerly_v3/features/business/screens/business_intro.dart';
//import 'package:ledgerly_v3/features/business/screens/business_success_screen.dart';
import 'package:ledgerly_v3/features/products/screens/products_intro_screen.dart';
import 'package:ledgerly_v3/features/products/screens/products_screen.dart';
import 'package:ledgerly_v3/features/products/screens/product_added_screen.dart';
import 'package:ledgerly_v3/features/products/screens/products_catalogue.dart';
import 'package:ledgerly_v3/features/sales/screens/sales_catalogue_screen.dart';
import 'package:ledgerly_v3/features/sales/screens/sales_intro_screen.dart';
import 'package:ledgerly_v3/features/expenses/screens/expenses_screen.dart';
import 'package:ledgerly_v3/features/expenses/screens/expenses_catalogue.dart';
import 'package:ledgerly_v3/features/insights/screens/insights_screen.dart';
import 'package:ledgerly_v3/features/sales/screens/sales_screen.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/product_provider.dart';
import 'core/providers/expense_provider.dart';
import 'package:ledgerly_v3/features/auth/screens/onboarding_screen.dart';

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
        theme: ThemeData(
          primarySwatch: Colors.teal,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const MultiStageSplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          //'/add-product': (context) => const AddProductSuccessScreen(),
          '/main': (context) => const MainScreen(),
          '/home': (context) => const HomeScreen(),
          '/business': (context) => const BusinessScreen(),
          '/business-intro': (context) => const BusinessIntroScreen(),
          //'/business-success': (context) => BusinessSuccessScreen(businessName: 'Default Business'),
          '/products-intro': (context) => const ProductsIntroScreen(),
          '/products/add': (context) => const AddProductFormScreen(),
          '/products/success': (context) => const ProductAddedScreen(),
          '/products-catalogue': (context) => const ProductsCatalogueScreen(),
          '/sales-catalogue': (context) => const SalesCatalogueScreen(),
          '/sales-intro': (context) => const SalesIntroScreen(),
          '/sales': (context) => const SalesScreen(),
          '/expenses': (context) => const ExpensesScreen(),
          '/expenses-catalogue': (context) => const ExpensesCatalogueScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
        },
      ),
    );
  }
}
