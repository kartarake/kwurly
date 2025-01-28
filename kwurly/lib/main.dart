// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:window_manager/window_manager.dart';
import 'package:kwurly/picker.dart';

/// Main application entry point
void main() async {
  // Initialize Flutter bindings and window manager
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // Configure window options
  const windowOptions = WindowOptions(
    size: Size(1280, 720),
    center: true,
    backgroundColor: Colors.transparent,
    titleBarStyle: TitleBarStyle.normal,
  );

  // Set up window and start app
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.maximize();
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

/// Root application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "kwurly",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

/// Main page widget with interactive elements
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _words = [];
  final ScrollController _scrollController = ScrollController();

  /// Adds new words to the list and scrolls to bottom
  void _addWords() {
    final newWords = pick(); // Get words from picker
    setState(() => _words.addAll(newWords));

    // Scroll to bottom after content updates
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
        actions: _appBarActions,
        elevation: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0, // Remove scroll shadow
      ),
      body: Container(
        decoration: _backgroundDecoration,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const InputBox(),  // Text input container
              const SizedBox(height: 40),
              _buildWordsContainer(), // Scrollable words grid
              const SizedBox(height: 50),
              _buildGenerateButton(), // Main action button
            ],
          ),
        ),
      ),
    );
  }

  /// Background gradient decoration
  static const _backgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.white, Color.fromARGB(255, 230, 230, 230)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  /// App bar action buttons
  final _appBarActions = [
    Padding(
      padding: const EdgeInsets.only(right: 15),
      child: IconButton(
        icon: SvgPicture.asset(
          "assets/icons/tabler--settings.svg",
          width: 24,
          height: 24,
        ),
        onPressed: () {}, // TODO: Add settings functionality
      ),
    ),
  ];

  /// Builds the scrollable words container
  Widget _buildWordsContainer() {
    return Container(
      height: 300,
      width: 1209,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 20,
          runSpacing: 30,
          children: _words.map(_buildWordChip).toList(),
        ),
      ),
    );
  }

  /// Creates an individual word chip
  Widget _buildWordChip(String word) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
    );
  }

  /// Builds the generate button
  Widget _buildGenerateButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 2,
        fixedSize: const Size(151, 60),
      ),
      onPressed: _addWords,
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
            "assets/icons/tabler--arrow-up-right.svg",
            width: 24,
            height: 24,
          ),
        ],
      ),
    );
  }
}

/// Custom input box with text field and action buttons
class InputBox extends StatelessWidget {
  const InputBox({super.key});

  @override
  Widget build(BuildContext context) {
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
          const Expanded(
            child: TextField(
              style: TextStyle(
                fontFamily: "Comic",
                fontSize: 18,
              ),
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Your idea goes here ..',
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 30,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  /// Builds the row of action buttons
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildIconButton("assets/icons/tabler--device-floppy.svg"),
          const SizedBox(width: 5),
          _buildIconButton("assets/icons/tabler--eraser.svg"),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  /// Creates a standardized icon button
  Widget _buildIconButton(String assetPath) {
    return IconButton(
      onPressed: () {}, // TODO: Add button functionality
      icon: SvgPicture.asset(
        assetPath,
        width: 24,
        height: 24,
      ),
    );
  }
}