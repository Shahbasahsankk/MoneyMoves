class WelcomeModel {
  final String image;
  final String text;

  WelcomeModel({required this.image, required this.text});
}

class SplashModel {
  final String text;
  final String author;

  SplashModel({required this.text, required this.author});
}

enum SidebarNavigationItem {
  home,
  categories,
  statistics,
  settings,
  share,
}
