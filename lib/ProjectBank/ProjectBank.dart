import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:impulse/UI/QnASection/ViewUserProfile.dart';
import 'SubmitProject-1.dart';

class ProjectBank extends StatefulWidget {
  @override
  _ProjectBankState createState() => _ProjectBankState();
}

class _ProjectBankState extends State<ProjectBank> {
  List<String> title = new List<String>();
  List<String> category = new List<String>();
  List<String> abstract = new List<String>();
  List<String> images = new List<String>();
  List<String> summary = new List<String>();
  List<String> name = new List<String>();

  TextEditingController searchTEC = new TextEditingController();

  String t;
  List filtered = [];
  bool isSearching = false;

  Widget allMailList() {
    double width = MediaQuery.of(context).size.width * 0.5;
    return SafeArea(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Row(mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(width: 20,),
              Container(width: MediaQuery
                  .of(context)
                  .size
                  .width / 1.5 + 50,
                child: TextFormField(
                  controller: searchTEC,
                  decoration: InputDecoration(
                      hintText: "Search projects by category..."
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                  onTap: () {
                    searchProject();
                  },
                  child: Icon(
                    Icons.search_rounded, size: 29, color: Colors.teal,)),
              SizedBox(width: 20,),
            ],
          ),
          SizedBox(height: 20,),
          Expanded(
            child: ListView.builder(
                      itemCount: (title.length != null) ? title.length : 0,
                      itemBuilder: (context, index) {
                        return ProjectTile(index, title[index], abstract[index], images[index],
                            width, category[index]);
                      }),
      ),
      ]
    ),
      );

  }

  @override
  void initState() {
    getProjects();
    super.initState();
  }

  getProjects() async {
    var n = await FirebaseFirestore.instance.collection("ProjectBank").orderBy('date',descending: true).get();
      for (int i = 0; i < n.docs.length; i++) {
        String a = n.docs[i].get('title').toString();
        String b = n.docs[i].get('category').toString();
        String c = n.docs[i].get('abstract').toString();
        String d = n.docs[i].get('image').toString();
        String e = n.docs[i].get('name').toString();
        setState(() {
          title.add(a);
          category.add(b);
          abstract.add(c);
          images.add(d);
          name.add(e);
        });
      }
  }

  searchProject() async {
    title=[];
    category=[];
    abstract=[];
    images=[];
    name=[];
    var n = await FirebaseFirestore.instance.collection("ProjectBank").orderBy('date',descending: true).get();
    for (int i = 0; i < n.docs.length; i++) {
      if(n.docs[i].get('category').toString().toLowerCase().compareTo(searchTEC.text.toLowerCase())==0) {
        String a = n.docs[i].get('title').toString();
        String b = n.docs[i].get('category').toString();
        String c = n.docs[i].get('abstract').toString();
        String d = n.docs[i].get('image').toString();
        String e = n.docs[i].get('name').toString();
        setState(() {
          title.add(a);
          category.add(b);
          abstract.add(c);
          images.add(d);
          name.add(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latest Projects', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.white,
      body: allMailList(),
      floatingActionButton: Container(alignment: Alignment.bottomRight,
        child: FloatingActionButton.extended(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitProject()));
          },
          label: Text("Submit Project",style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }


  Widget ProjectTile(int ind, String title, String abstract, String img, double width, String category,) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProjectPg(title,abstract)));
      },
      child: Card(
        color: Colors.grey.shade50,
        child: SingleChildScrollView(scrollDirection: Axis.horizontal,
          child: Row(children: [
            Container(
              width: 150,
              height: 150,
              child: (img.length!=4)?Image.network(img,fit: BoxFit.cover,):Column(
                crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_not_supported_outlined,size: 40,color: Colors.grey,),
                  Text("No Image",style: TextStyle(color: Colors.grey),)
                ],
              ),),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${title.trim()}", style: TextStyle(color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),),
                  SizedBox(height: 10),

                  Container(
                      width: width,
                      child: Text("${abstract.trim().substring(0,abstract.length>50?50:abstract.length)}${abstract.length>50?"...":""}", style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 17,
                          fontWeight: FontWeight.normal),)
                  ),
                  SizedBox(height: 5),
                  Container(
                    child: Text("#${category.trim()}", style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),),
                  ),
                  SizedBox(height: 5,),
                  Text("Uploaded by"),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Container(
                        child: CircleAvatar(
                          backgroundColor: Colors.teal,
                          radius: 15,
                          child: Text("${name[ind][0]}", //userName.substring(0,1).toUpperCase()
                            style: TextStyle(color: Colors.white, fontSize: 20),),
                        ),),
                      SizedBox(width: 5,),
                      Text("${name[ind]}",style: TextStyle(color: Colors.black87, fontSize: 18)),
                    ],
                  )
                ],
              ),
            )
          ],),
        ),

      ),
    );
  }

}