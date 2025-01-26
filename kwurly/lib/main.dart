import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:window_manager/window_manager.dart';

import 'package:kwurly/picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 720),
    center: true,
    backgroundColor: Colors.transparent,
    titleBarStyle: TitleBarStyle.normal,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    // Maximize the window when ready
    await windowManager.maximize();
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "kwurly",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> words = [];
  final ScrollController _scrollController = ScrollController();

  void addWords() {
    List<String> newWords = pick();

    setState(() {
      words.addAll(newWords);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: actionlist,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color.fromARGB(255, 230, 230, 230)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getinputbox(),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: 1209,
                  height: 600,
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Wrap(
                      spacing: 30,
                      runSpacing: 30,
                      children: words
                          .map(
                            (word) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                word,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Comic",
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 2,
                  fixedSize: const Size(151, 60),
                ),
                
                onPressed: addWords,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Generate",
                      style: TextStyle(
                        fontFamily: "Comic",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 7),
                    SvgPicture.asset(
                      "assets\\icons\\tabler--arrow-up-right.svg",
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

var actionlist = [
  Padding(
    padding: const EdgeInsets.only(right: 15),
    child: IconButton(
      icon: SvgPicture.asset(
        "assets\\icons\\tabler--settings.svg",
        width: 24,
        height: 24,
      ),
      onPressed: () {},
    ),
  ),
];

Container getinputbox() {
  return Container(
    width: 1209,
    height: 211,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: const Color(0xff191919),
        width: 0.5,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        const TextField(
          style: TextStyle(
            fontFamily: "Comic",
            fontSize: 18,
          ),
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Your idea goes here ..',
            hintFadeDuration: Duration(milliseconds: 500),
            hintStyle: TextStyle(color: Colors.grey),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 30,
            ),
            border: InputBorder.none,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets\\icons\\tabler--device-floppy.svg",
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(width: 5),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets\\icons\\tabler--eraser.svg",
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
        const SizedBox(height: 10),
      ],
    ),
  );
}
