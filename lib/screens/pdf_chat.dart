// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final messageInsert = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  final String apiKey = 'sec_XLtfIFNWIjahB2s677hUPKxAN25p95ve';
  final String sourceId = 'src_qaxTfmaEQGUTcMtznG6Ie';

  void sendMessageToChatPDF(String query) async {
    final url = Uri.parse('https://api.chatpdf.com/v1/chats/message');
    final headers = {
      'x-api-key': apiKey,
      'Content-Type': 'application/json',
    };
    final request = jsonEncode({
      'sourceId': sourceId,
      'messages': [
        {'role': 'user', 'content': query},
      ],
    });

    final response = await http.post(url, headers: headers, body: request);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        messages.insert(0, {"data": 0, "message": responseData['content']});
      });
    } else {
      print('Failed to send message. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        elevation: 10,
        title: const Text("ChatPDF-Powered Chatbot"),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) => chat(
                    messages[index]["message"].toString(),
                    messages[index]["data"])),
          ),
          const Divider(
            height: 6.0,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20),
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Flexible(
                    child: TextField(
                  controller: messageInsert,
                  decoration: const InputDecoration.collapsed(
                      hintText: "Send your message",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0)),
                )),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          size: 30.0,
                        ),
                        onPressed: () {
                          if (messageInsert.text.isEmpty) {
                            print('Empty message');
                          } else {
                            setState(() {
                              messages.insert(0,
                                  {"data": 1, "message": messageInsert.text});
                            });
                            sendMessageToChatPDF(messageInsert.text);
                            messageInsert.clear();
                          }
                        })),
              ],
            ),
          ),
          const SizedBox(
            height: 15.0,
          )
        ],
      ),
    );
  }

  Widget chat(String message, int data) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Bubble(
        radius: const Radius.circular(15.0),
        color: data == 0 ? Colors.blue : Colors.orangeAccent,
        elevation: 0.0,
        alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
        nip: data == 0 ? BubbleNip.leftBottom : BubbleNip.rightTop,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage(
                    data == 0 ? "assets/bot.png" : "assets/profile.png"),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Flexible(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  decoration: BoxDecoration(
                    color: data == 0 ? Colors.blue : Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: MarkdownBody(
                    selectable: true,
                    data: message,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
