import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/chatroom_model.dart';
import '../model/user_model.dart';
import 'chats_screen.dart';
import 'package:uuid/uuid.dart';

class SearchScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchScreen(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  var uuid = Uuid();

  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      // Fetch the existing one
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
    } else {
      // Create a new one
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.userModel.uid.toString(): true,
          targetUser.uid.toString(): true,
        },
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;

      print("New Chatroom Created!");
    }

    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(labelText: "Email Address"),
              ),
              const SizedBox(
                height: 20,
              ),
              CupertinoButton(
                onPressed: () {
                  setState(() {});
                },
                color: Theme.of(context).colorScheme.secondary,
                child: const Text("Search"),
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where("email", isEqualTo: searchController.text)
                      .where("email", isNotEqualTo: widget.userModel.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;

                        if (dataSnapshot.docs.length > 0) {
                          Map<String, dynamic> userMap = dataSnapshot.docs[0]
                              .data() as Map<String, dynamic>;

                          UserModel searchedUser = UserModel.fromMap(userMap);

                          return ListTile(
                            onTap: () async {
                              ChatRoomModel? chatroomModel =
                                  await getChatroomModel(searchedUser);

                              if (chatroomModel != null) {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatRoomPage(
                                              targetUser: searchedUser,
                                              userModel: widget.userModel,
                                              firebaseUser: widget.firebaseUser,
                                              chatroom: chatroomModel,
                                            )));
                              }
                            },
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(searchedUser.profilepic!),
                              backgroundColor: Colors.grey[500],
                            ),
                            title: Text(searchedUser.fullname!),
                            subtitle: Text(searchedUser.email!),
                            trailing: Icon(Icons.keyboard_arrow_right),
                          );
                        } else {
                          return Text("No results found!");
                        }
                      } else if (snapshot.hasError) {
                        return Text("An error occured!");
                      } else {
                        return Text("No results found!");
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
