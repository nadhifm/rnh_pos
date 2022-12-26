import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:rnh_pos/domain/entities/product.dart';
import 'package:rnh_pos/presentation/pages/add_edit_product.dart';
import 'package:rnh_pos/presentation/pages/confirmation_transaction_page.dart';
import 'package:rnh_pos/presentation/pages/home_page.dart';
import 'package:rnh_pos/presentation/pages/sign_in_page.dart';
import 'package:rnh_pos/presentation/pages/splash_page.dart';
import 'package:rnh_pos/presentation/pages/success_transaction_page.dart';
import 'package:rnh_pos/presentation/pages/success_transaction_page.dart';
import 'package:rnh_pos/presentation/pages/transaction_detail_page.dart';
import 'package:rnh_pos/presentation/provider/add_edit_product_notifier.dart';
import 'package:rnh_pos/presentation/provider/category_notifier.dart';
import 'package:rnh_pos/presentation/provider/check_user_notifier.dart';
import 'package:rnh_pos/presentation/provider/product_notifier.dart';
import 'package:rnh_pos/presentation/provider/report_notifier.dart';
import 'package:rnh_pos/presentation/provider/sign_in_notifier.dart';
import 'package:rnh_pos/presentation/provider/drawer_page_notifier.dart';
import 'package:rnh_pos/presentation/provider/transaction_notifier.dart';
import 'commont/utils.dart';
import 'domain/entities/transaction.dart';
import 'firebase_options.dart';
import 'package:rnh_pos/injection.dart' as di;

import 'presentation/pages/pay_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<SignInNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<CheckUserNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<AddEditProductNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<ProductNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<CategoryNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TransactionNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<ReportNotifier>(),
        ),
        ChangeNotifierProvider(create: (_) => DrawerPageNotifier())
      ],
      child: MaterialApp(
        title: 'RnH POS',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFFEDE6DB),
          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0x40417D7A)),
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF1A3C40)),
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
          ),
        ),
        navigatorObservers: [routeObserver],
        home: const SplashPage(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case SplashPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => const SplashPage());
            case SignInPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => const SignInPage());
            case HomePage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => const HomePage());
            case AddEditProduct.ROUTE_NAME:
              final product = settings.arguments as Product?;
              return MaterialPageRoute(
                builder: (_) => AddEditProduct(
                  product: product,
                ),
                settings: settings,
              );
            case ConfirmationTransactionPage.ROUTE_NAME:
              return MaterialPageRoute(
                  builder: (_) => const ConfirmationTransactionPage());
            case PayPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => const PayPage());
            case SuccessTransactionPage.ROUTE_NAME:
              final transaction = settings.arguments as Transaction;
              return MaterialPageRoute(
                builder: (_) => SuccessTransactionPage(
                  transaction: transaction,
                ),
                settings: settings,
              );
            case TransactionDetailPage.ROUTE_NAME:
              final transaction = settings.arguments as Transaction;
              return MaterialPageRoute(
                builder: (_) => TransactionDetailPage(
                  transaction: transaction,
                ),
                settings: settings,
              );
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return const Scaffold(
                    body: Center(
                      child: Text('Page not found :('),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
