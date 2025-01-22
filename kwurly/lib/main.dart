import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:window_manager/window_manager.dart';

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
      title:"kwurly",
      debugShowCheckedModeBanner: false,
      home:HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: actionlist,
        elevation: 0,
      ),

      body: Scaffold(
        body: Center(
          child: getinputbox() 
        )
      )
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
    height: 177+34,

    decoration: BoxDecoration(
      border: Border.all(
        color: Color(0xff191919),
        width: 0.5,
      ),
      borderRadius: BorderRadius.circular(20)
    ),
    
    child: Column(
      children: [
        TextField(
          style: TextStyle(
            fontFamily: "Comic",
            fontSize: 18,
          ),
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Your idea goes here ..',
            hintFadeDuration: Duration(milliseconds: 500),
            hintStyle: TextStyle(
              color: Colors.grey
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 30
            ),
            border: InputBorder.none
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
              )
            ),

            SizedBox(width: 5),

            IconButton(
              onPressed: () {}, 
              icon: SvgPicture.asset(
                "assets\\icons\\tabler--eraser.svg",
                width: 24,
                height: 24,
              )
            ),

            SizedBox(width: 20)
          ],
        ),

        SizedBox(height: 10)
      ]      
    )
  );
}
