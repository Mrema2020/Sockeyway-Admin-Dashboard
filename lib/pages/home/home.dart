import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sockeyway_web/pages/home/dashboard_screen.dart';
import 'package:sockeyway_web/pages/home/fixture_screen.dart';
import 'package:sockeyway_web/pages/home/player_cv.dart';
import 'package:sockeyway_web/pages/home/post_screen.dart';
import 'package:sockeyway_web/pages/home/tickets.dart';
import 'package:sockeyway_web/utils/colors.dart';
import 'package:sockeyway_web/widgets/logout_dialog.dart';

import 'news_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var pageIndex;
  var selectedIndex;
  var name;
  var icon;
  var userDetails;
  var dashboardData;
  Color? selectedColor;
  Color? selectedTextColor;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: const Color(0xFFf8f9fa),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _sideMenu(),
                  _contentsPage(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _sideMenu() {
    var appHeight = MediaQuery.of(context).size.height;
    var appWidth = MediaQuery.of(context).size.width;
    return Container(
      width: 210,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.primaryColor,
            Colors.white,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: appWidth * 0.01,
          top: appHeight * 0.01,
          right: appWidth * 0.01,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              itemCount: 6,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context, int index) {
                if (selectedIndex == index) {
                  selectedColor = AppColors.primaryColor.withOpacity(0.1);
                  selectedTextColor = Colors.white;
                } else {
                  selectedColor = Colors.transparent;
                  selectedTextColor = AppColors.secondaryColor.withOpacity(0.6);
                }
                if (index == 0) {
                  name = 'Dashboard';
                  icon = CupertinoIcons.house_fill;
                  // pageIndex = 1;
                } else if (index == 1) {
                  name = 'Posts';
                  icon = CupertinoIcons.pencil_ellipsis_rectangle;
                  // pageIndex = 2;
                } else if (index == 2) {
                  name = 'News';
                  icon = CupertinoIcons.desktopcomputer;
                  // pageIndex = 3;
                } else if (index == 3) {
                  name = 'Fixtures';
                  icon = Icons.sports_soccer;
                  // pageIndex = 4;
                } else if (index == 4) {
                  name = 'Player Cv';
                  icon = CupertinoIcons.profile_circled;
                  // pageIndex = 4;
                } else if (index == 5) {
                  name = 'Tickets';
                  icon = CupertinoIcons.tickets;
                  // pageIndex = 4;
                }
                return InkWell(
                  mouseCursor: MouseCursor.uncontrolled,
                  onTap: () => {
                    setState(
                      () {
                        selectedIndex = index;
                        // pageIndex = index == null ? 0 : index + 1;
                        if (index == 0) {
                          pageIndex = 1;
                        } else if (index == 1) {
                          pageIndex = 2;
                        } else if (index == 2) {
                          pageIndex = 3;
                        } else if (index == 3) {
                          pageIndex = 4;
                        } else if (index == 4) {
                          pageIndex = 5;
                        } else if (index == 5) {
                          pageIndex = 6;
                        }
                      },
                    ),
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedColor,
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(2)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              icon,
                              size: 30,
                              color: selectedTextColor,
                            ),
                            const SizedBox(width: 20),
                            Text(
                              name,
                              style: TextStyle(
                                color: selectedTextColor,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Container(
              height: MediaQuery.of(context).size.height / 12,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.2),
                borderRadius: const BorderRadius.only(topRight: Radius.circular(20)),
              ),
              child: TextButton(
                onPressed: () => {showDialog(context: context, builder: (_) => const LogoutDialog())},
                child: Row(
                  children: [
                    const Icon(
                      Icons.logout,
                      size: 30,
                      color: AppColors.secondaryColor,
                    ),
                    SizedBox(width: appWidth * 0.01),
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: AppColors.secondaryColor.withOpacity(0.7),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 5.5,
            ),
          ],
        ),
      ),
    );
  }

  _contentsPage() {
    if (pageIndex == 1) {
      return Expanded(
        child: DashboardScreen(),
      );
    } else if (pageIndex == 2) {
      return Expanded(
        child: PostScreen(),
      );
    } else if (pageIndex == 3) {
      return const Expanded(
        child: NewsScreen(),
      );
    } else if (pageIndex == 4) {
      return const Expanded(
        child: FixturesScreen(),
      );
    } else if (pageIndex == 5) {
      return const Expanded(
        child: PlayerCvPage(),
      );
    } else if (pageIndex == 6) {
      return const Expanded(
        child: TicketsPage(),
      );
    } else {
      return Expanded(child: DashboardScreen());
    }
  }
}
