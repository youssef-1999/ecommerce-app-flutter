import 'package:flutter/material.dart';
// this is clean code for navigation service to use in the app for navigation between screens without context 
// and also routing at the same time 
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}
