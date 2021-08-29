import'package:cloud_firestore/cloud_firestore.dart';
import 'package:impulse/Model/todo.dart';


class DatabaseService {
  CollectionReference todosCollection =
  FirebaseFirestore.instance.collection("Todos");

  Future createNewTodo(String title,String mail) async {
    return await todosCollection.add({
      "title": title,
      "isComplete": false,
      "mail": mail,
      "Time": DateTime.now().toString()
    });
  }

  Future completTask(uid,bool val) async {
    await todosCollection.doc(uid).update({"isComplete": val});
  }

  Future removeTodo(uid) async {
    await todosCollection.doc(uid).delete();
  }

  List<Todo> todoFromFirestore(QuerySnapshot snapshot) {

    if (snapshot != null) {
      return snapshot.docs.map((data) {
        return Todo(
          isComplete: data['isComplete'],
          title: data['title'],
          mail: data['mail'],
          uid: data.id,
          time: data['Time']
        );
      }).toList();
    } else {
      return null;
    }
  }

  Stream<List<Todo>> listTodos() {
    return todosCollection.orderBy('Time',descending: true).snapshots().map(todoFromFirestore);
  }
}
