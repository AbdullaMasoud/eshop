import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'Layouts/shopLayout.dart';
import 'cubit/appCubit.dart';
import 'cubit/shopCubit.dart';
import 'cubit/states.dart';
import 'modules/LoginScreen.dart';
import 'modules/OnBoardingScreen.dart';
import 'modules/splashScreen.dart';
import 'remoteNetwork/cacheHelper.dart';
import 'remoteNetwork/dioHelper.dart';
import 'shared/bloc_observer.dart';
import 'shared/constants.dart';
import 'shared/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  Widget widget;

  bool? isDark = CacheHelper.getData('isDark');
  bool? showOnBoard = CacheHelper.getData('ShowOnBoard');
  token = CacheHelper.getData('token');

  if (showOnBoard == false) {
    if (token != null) {
      widget = ShopLayout();
    } else {
      widget = LoginScreen();
    }
  } else {
    widget = OnBoarding();
  }
  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  final Widget startWidget;
  const MyApp({this.isDark, required this.startWidget});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AppCubit()),
          BlocProvider(
              create: (context) => ShopCubit()
                ..getHomeData()
                ..getCategoryData()
                ..getFavoriteData()
                ..getProfileData()
                ..getCartData()
                ..getAddresses()),
        ],
        child: BlocConsumer<AppCubit, ShopStates>(
            listener: (context, state) {},
            builder: (context, state) {
              AppCubit cubit = AppCubit.get(context);
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: AnimatedSplashScreen(
                  splash: SplashScreen(),
                  nextScreen: startWidget,
                  splashIconSize: 700,
                  backgroundColor: Colors.white,
                  animationDuration: const Duration(milliseconds: 2000),
                  splashTransition: SplashTransition.fadeTransition,
                ),
                theme: lightMode(),
                darkTheme: darkMode(),
                themeMode: cubit.appMode,
              );
            }));
  }
}
