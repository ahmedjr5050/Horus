// ignore_for_file: file_names, unused_local_variable
import 'package:apps/core/routing/routes.dart';
import 'package:flutter/material.dart';
import '../../feature/Details/persentation/deatils_view.dart';
import '../../feature/chatapp/screen/chatpage.dart';
import '../../feature/closest_places/presentation/closest_places_view.dart';
import '../../feature/detects_action/presentation/widgets/detectsView.dart';
import '../../feature/home/homescreen.dart';
import '../../feature/onboard/onboard.dart';
import '../../feature/scan/getimages.dart';
import '../../feature/signin/forget/passwordforget.dart';
import '../../feature/signin/login_screen.dart';
import '../../feature/signup/signup_screen.dart';
import '../../feature/splash/splash_screen.dart';
import '../../feature/tourism_type/presentation/toursim_type_view.dart';
import '../../location.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    //this arguments is used to pass data from one screen to another
    final arguments = settings.arguments;
    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(
          builder: (_) => const OnBoard(),
        );
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case Routes.signUpScreen:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
        );
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case Routes.splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case Routes.imagePickerDemo:
        return MaterialPageRoute(
          builder: (_) => const ImagePickerDemo(),
        );
      case Routes.detailsView:
        return MaterialPageRoute(
          builder: (_) => const DetailsView(
            '',
          ),
        );
      case Routes.detectView:
        return MaterialPageRoute(
          builder: (_) => const DetectView(),
        );
      case Routes.closestPlacesView:
        return MaterialPageRoute(
          builder: (_) => const ClosesPLaces(),
        );
      case Routes.tourimTypeView:
        return MaterialPageRoute(
          builder: (_) => const TourismType(),
        );
      case Routes.forgetPassword:
        return MaterialPageRoute(
          builder: (_) => Forget(),
        );
      case Routes.chatScreen:
        return MaterialPageRoute(
          builder: (_) => const ChatPage(),
        );
      case Routes.locationScreen:
        return MaterialPageRoute(
          builder: (_) => const MapScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
