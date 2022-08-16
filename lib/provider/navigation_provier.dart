import 'package:flutter/cupertino.dart';
import 'package:project/Models/model_classes.dart';

class NavigationProvider extends ChangeNotifier {
  SidebarNavigationItem _navigationItem = SidebarNavigationItem.home;

  SidebarNavigationItem get navigationItem => _navigationItem;

  void setNavigationItem(SidebarNavigationItem navigationItem){
    _navigationItem=navigationItem;

    notifyListeners();
  }
}
