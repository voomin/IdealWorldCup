import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ideal Choice',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pack List view")),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          
        }),
        tooltip: 'Pack maker',
        child: Icon(Icons.add),
      ),
    );
  }
  Widget _buildBody(BuildContext context) {
   return StreamBuilder<QuerySnapshot>(
     stream: Firestore.instance.collection('Pack').snapshots(),
     builder: (context, snapshot) {
       if (!snapshot.hasData) return LinearProgressIndicator();

       return _buildList(context, snapshot.data.documents);
     },
   );
 }
 
 Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
   return ListView(
     padding: const EdgeInsets.only(top: 20.0),
     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
   );
 }

 Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
   final pack = Pack.fromSnapshot(data);

   return Padding(
     key: ValueKey(pack.pack_id),
     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
     child: Container(
       decoration: BoxDecoration(
         border: Border.all(color: Colors.grey),
         borderRadius: BorderRadius.circular(5.0),
       ),
       child: ListTile(
         title: Text(pack.title),
         trailing: Text(pack.Explanation),
         onTap: () => showDialog(context:context,child:new SimpleDialog(
                          title:new Text(pack.title),
                          children: <Widget>[
                            new SimpleDialogOption(child: new Text(pack.Explanation)),
                            new SimpleDialogOption(child: new Text("info"), onPressed: (){}),
                            new SimpleDialogOption(
                              child: new Container(
                                  child: new Text("START",          
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white
                                  )
                                ),
                              decoration: new BoxDecoration (
                                borderRadius: BorderRadius.circular(5.0),
                                border: new Border.all(color: Colors.black),
                                color: Colors.green
                              ),
                              padding: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                                
                              ),
                              onPressed: (){},
                            )  
                          ],
                      ))
       ),
     ),
   );
 }

}
class Pack {
 final String pack_id;
 final String title;
 final String Explanation;
 final DocumentReference reference;

 Pack.fromMap(Map<String, dynamic> map, {this.reference})
     : assert(map['pack_id'] != null),
       assert(map['title'] != null),
       assert(map['Explanation'] != null),
       pack_id = map['pack_id'],
       title = map['title'],
       Explanation = map['Explanation'];

 Pack.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);

 @override
 String toString() => "pack [ $title:$Explanation]";
}
