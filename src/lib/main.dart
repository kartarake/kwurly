// main.dart
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:kwurly/ideas.dart';
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
    return ChangeNotifierProvider(
      create: (context) => IdeaTrack(),
      child: MaterialApp(
        title: "kwurly",
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      )
    );
  }
}

class IdeaTrack extends ChangeNotifier {
  String _current = "";
  
  String get current => _current;
  
  void setCurrent(String value) {
    _current = value;
    notifyListeners();
  }
  
  String toStringRep() => _current.isEmpty 
      ? "No Track Selected" 
      : "Track Selected: $_current";
}

/// Main page widget with interactive elements
class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
    final ideaTrack = Provider.of<IdeaTrack>(context);

    return Scaffold(
      appBar: AppBar(
        // actions: _appBarActions,
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
              Text(ideaTrack.toStringRep()),
              InputBox(),  // Text input container
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
        onPressed: () {},
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
class InputBox extends StatefulWidget {
  const InputBox({super.key});

  @override
  State<InputBox> createState() => InputBoxState();
}

class InputBoxState extends State<InputBox> {
  final _textController = TextEditingController();  
  @override  void dispose() {
    _textController.dispose();
    super.dispose();
  }

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
          Expanded(
            child: TextField(
              controller: _textController,
              style: TextStyle(
                fontFamily: "Comic",
                fontSize: 18,
                fontWeight: FontWeight.bold
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
          _buildActionButtons(_textController),
        ],
      ),
    );
  }

  /// Builds the row of action buttons
  Widget _buildActionButtons(TextEditingController textController) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildNewButton(textController, context),
          const SizedBox(width: 5),
          _buildSaveButton(textController),
          const SizedBox(width: 5),
          _buildEraseButton(textController),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  /// Creates a standardized icon button
  Widget _buildEraseButton(TextEditingController textController) {
    return IconButton(
      tooltip: "Clear Idea",
      onPressed: () {textController.clear();},
      icon: SvgPicture.asset(
        "assets\\icons\\cloud-erase.svg",
        width: 24,
        height: 24,
      ),
    );
  }

  Widget _buildSaveButton(TextEditingController textController) {
    final ideaTrack = Provider.of<IdeaTrack>(context, listen: false);

    return IconButton(
      tooltip: "Save Idea",
      onPressed: () {saveIdea(ideaTrack.current, textController.text);},
      icon: SvgPicture.asset(
        "assets\\icons\\cloud-save.svg",
        width: 24,
        height: 24,
      ),
    );
  }
}

Widget _buildNewButton(TextEditingController textController, BuildContext context) {
  return IconButton(
    tooltip: "New Idea",
    onPressed: () {newIdeaTitleInputDialog(context, textController);},
    icon: SvgPicture.asset(
      "assets\\icons\\cloud-add.svg",
      width: 24,
      height: 24,
    ),
  );
}

void newIdeaTitleInputDialog (BuildContext context, TextEditingController textController) {
  TextEditingController titleInputController = TextEditingController();
  final ideaTrack = Provider.of<IdeaTrack>(context, listen: false);

  TextField titleInputBox = TextField(
    decoration: InputDecoration(
      hintText: "Enter your title here",
      hintMaxLines: 1,
      hintStyle: TextStyle(
        fontFamily: "Comic",
        fontSize: 18,
      ),
    ),
    controller: titleInputController
  );

  TextButton cancelButton = TextButton(
    onPressed: () {
      Navigator.of(context).pop();
    },
    child: Text(
      "Cancel",
      style: TextStyle(
        fontFamily: "Comic",
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.grey
      ),      
    ),
  );

  TextButton createButton = TextButton(
    onPressed:() {
      saveIdea(titleInputController.text, "");
      Navigator.of(context).pop();
      ideaTrack.setCurrent(titleInputController.text);
      textController.clear();
    }, 

    child: Text(
      "Create",
      style: TextStyle(
        fontFamily: "Comic",
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black
      ),
    )
  );

  showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          titleInputBox
        ],
      ),

      actions: [
        cancelButton,
        createButton
      ],
    );
  });
}