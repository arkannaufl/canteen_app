import 'package:canteen_app/data/dataresource/auth_local_datasource.dart';
import 'package:canteen_app/presentation/auth/blocs/login/login_bloc.dart';
import 'package:canteen_app/presentation/general/dashboard_page.dart';
import 'package:canteen_app/presentation/general/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data/dataresource/auth_remote_datasource.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(AuthRemoteDatasource()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: GoogleFonts
              .poppins()
              .fontFamily,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
          useMaterial3: true,
        ),
        home: FutureBuilder(
            future: AuthLocalSource().isAuthData(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return const DashboardPage();
              } else {
              return const SplashPage();
              }
            }
        ),
      ),
    );
  }
}
