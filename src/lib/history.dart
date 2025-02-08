import 'package:flutter/material.dart';
import 'package:kwurly/ideas.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xfff5f5f5),
        scrolledUnderElevation: 0, // Remove scroll shadow
      ),
      body: Center(
        child: buildHistoryPage(),
      ),
    );
  }
}

Widget buildHistoryPage() {
  return Container(
    padding: EdgeInsets.all(16),
    color: Color(0xfff5f5f5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Idea Tracks",
          style: TextStyle(
            fontFamily: "Comic",
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 30),
        // Expanded so the table can use available space.
        Expanded(child: buildTable()),
      ],
    ),
  );
}

Widget buildTable() {
  if (!anyIdeaTrack()) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          "No idea tracks yet",
          style: TextStyle(
            fontFamily: "Comic",
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  } else {
    List ideas = loadIdeas();
    for (dynamic idea in ideas) {
      if (idea["ideatrack"] == "") idea["ideatrack"] = "Untitled";
      if (idea["idea"] == "") idea["idea"] = "No body";
    }
    List<TableRow> rows = ideas.map<TableRow>((idea) {
      return buildIdeaTrackRow(idea["ideatrack"], idea["idea"]);
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: rows,
      ),
    );
  }
}

TableRow buildIdeaTrackRow(String ideaTrack, String idea) {
  return TableRow(
    children: [
      // Wrap the entire row content in an InkWell to make it clickable.
      InkWell(
        onTap: () {
          print("Tapped on $ideaTrack");
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Text(
                ideaTrack,
                style: TextStyle(
                  fontFamily: "Comic",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Stack(
                  children: [
                    Text(
                      idea,
                      style: TextStyle(
                        fontFamily: "Comic",
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    // This gradient container overlays the text (if that’s your intended effect).
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0x00ffffff),
                              Color(0xffffffff),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
        ),
      ),
    ],
  );
}
