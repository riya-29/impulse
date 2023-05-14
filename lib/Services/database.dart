import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  getUserByUsername(String username,String Field) async {
    return await FirebaseFirestore.instance.collection("Users").where(Field, isEqualTo: username).get();
  }
  getGroupByGroupName(String Category) async {
  return await FirebaseFirestore.instance.collection("Groups").where("Category", isEqualTo: Category).get();
  }

  //used in sign in method
  getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance.collection("Users").where("Email", isEqualTo: userEmail).get();
  }

  uploadUserInfo(userMap) async {
    print(userMap["Email"]);
    await FirebaseFirestore.instance.collection("Users").doc(userMap["Email"]).set(userMap);/*.catchError((e){  print("print"+e.toString());  });*/
  }

  getUserDocList() async{
    return await FirebaseFirestore.instance.collection("Users").get();
  }

  //Personal Chats
  createChatRoom(String chatRoomId,chatRoomMap){
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).set(chatRoomMap).catchError((e){print(e.toString());});
  }
  addConversation(String RoomId,messageMap){
    FirebaseFirestore.instance.collection("ChatRoom").doc("$RoomId").collection("chats").add(messageMap).catchError((e){print(e.toString());});
  }

  getConversation(String RoomId) async{
    return FirebaseFirestore.instance.collection("ChatRoom").doc("$RoomId").collection("chats").orderBy("time",descending: true).snapshots();
  }

  //Groups
  createGroupChatRoom(String GroupName,groupChatRoomMap){
    FirebaseFirestore.instance.collection("Groups").doc(GroupName).set(groupChatRoomMap).catchError((e){print(e.toString());});
  }

  addGroupConversation(String groupName,messageMap){
    FirebaseFirestore.instance.collection("Groups").doc("$groupName").collection("chats").add(messageMap).catchError((e){print(e.toString());});
  }
  getGroupConversation(String groupName) async{
    return FirebaseFirestore.instance.collection("Groups").doc("$groupName").collection("chats").orderBy("time",descending: true).snapshots();
  }
  getGroupChatRooms(String userName) async{
    return FirebaseFirestore.instance.collection("Groups").where("Members",arrayContains: userName,).snapshots();
  }

  getChatRooms(String userName) async{
    return FirebaseFirestore.instance.collection("ChatRoom").where("users",arrayContains: userName,).snapshots();
  }
}

