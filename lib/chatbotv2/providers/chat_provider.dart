import 'package:flutter/cupertino.dart';
import '../models/chat_model.dart';

class ChatProviderv2 with ChangeNotifier {
  List<ChatModel> chatList = [];

  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  void addBotMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 1));
    notifyListeners();
  }
}
