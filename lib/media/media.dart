import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widget.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({
    super.key,
  });

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  late final StatefulNavigationShell navigationShell;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/LSeed-Logo-1.png',
                        scale: 5,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Media',
                        style: TextStyle(
                          fontFamily: 'Playfair',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicatorColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                      indicator: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                      ),
                      tabs: [
                        Tab(
                          child: Text(
                            'Audio',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12.0,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Video',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12.0,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: const TabBarView(
                      children: [AudioMessages(), VideoMessages()],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
