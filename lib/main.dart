import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
//import './screens/products_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';
import './providers/purchases_provider.dart';
import './providers/product_provider.dart';
import './providers/sales_provider.dart';
import './database/db_helper.dart';
import './providers/notification_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import './constants/notification_service.dart';
//import './screens/auth/register_screen.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs=await SharedPreferences.getInstance();
  bool onboardingcompleted=prefs.getBool("onboarding_completed")??false;
  await DatabaseHelper.instance.database;
  await NotificationService.initialize();
  //await SaleProvider.lo
  runApp(MyApp(startScren: onboardingcompleted ? LoginScreen() : OnboardingScreen()));
}



class MyApp extends StatelessWidget {
  final Widget startScren;
  MyApp({required this.startScren});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_)=>PurchaseProvider()),
        ChangeNotifierProvider(create: (_)=>ProductProvider()),
         ChangeNotifierProvider(create: (_)=>SaleProvider()),
         ChangeNotifierProvider(create: (_)=>NotificationsProvider()),
      
      ],
  child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.cairoTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.blue),
      home: startScren,
  )
    );
  }
}
