import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:impulse/UI/dashboard.dart';

class SearchProject extends StatefulWidget{
  @override
  _SearchProjectState createState() => _SearchProjectState();
}

class _SearchProjectState extends State<SearchProject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Queries"), backgroundColor: Colors.teal,),
      drawer: NavDrawer(),
      backgroundColor: Colors.grey.shade50,
      bottomNavigationBar: homeBottomNavigationBar(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            // Row(mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     SizedBox(width: 20,),
            //     Container(width: MediaQuery
            //         .of(context)
            //         .size
            //         .width / 1.5 + 50,
            //       child: TextFormField(
            //         controller: searchTEC,
            //         decoration: InputDecoration(
            //             hintText: "Search queries..."
            //         ),
            //       ),
            //     ),
            //     Spacer(),
            //     GestureDetector(
            //         onTap: () {
            //           searchQuestion();
            //         },
            //         child: Icon(
            //           Icons.search_rounded, size: 29, color: Colors.teal,)),
            //     SizedBox(width: 20,),
            //   ],
            // ),
            SizedBox(height: 10,),
            //unansweredList(),
          ],
        ),
      ),
    );
  }
}