import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:speech_to_text/speech_recognition_result.dart';
import '../custom_widgets/bubble_message_job_search.dart';
import '../utils/constants.dart';
import '../utils/local_db.dart';
import 'home_screen.dart';

const String websocketUrlForJob = 'wss://beta-staging-backend.crewdog.ai/ws/job_search/';
const String websocketUrlForProfile = 'wss://beta-staging-backend.crewdog.ai/ws/profile_search/';
String websocketUrl = websocketUrlForJob;
final FocusNode _focusNode = FocusNode();

class JobSearchScreen extends StatefulWidget {
  const JobSearchScreen({Key? key}) : super(key: key);

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  late WebSocketChannel channel;
  bool isConnected = false;
  bool isLoading = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _connectWebSocket();
  }

  void _handleTabSelection() {
    if (_tabController.index == 0) {
      websocketUrl = websocketUrlForJob;
      refreshResponse();
    } else {
      websocketUrl = websocketUrlForProfile;
      refreshResponse();
    }
    _reconnectWebSocket();
  }

  void _connectWebSocket() {
    print('Connecting to WebSocket...');
    channel = WebSocketChannel.connect(Uri.parse(websocketUrl));

    channel.stream.listen(
      (message) {
        final decodedMessage = jsonDecode(message);
        print('Received: $decodedMessage');
        if (decodedMessage['type'] == 'ack') {
          print('Acknowledgment received: ${decodedMessage['message']}');
        } else {
          setState(() {
            if (decodedMessage['type'] == 'answer') {
              _messages.add({'message': decodedMessage['message'], 'isUser': false});
              isLoading = false; // Stop showing the loading indicator
              _scrollToBottom();
            }
          });
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
        _reconnectWebSocket();
      },
      onDone: () {
        print('WebSocket closed with status: ${channel.closeCode}, reason: ${channel.closeReason}');
        _reconnectWebSocket();
      },
    );
  }

  void _reconnectWebSocket() {
    if (!isConnected) {
      Future.delayed(const Duration(seconds: 1), () {
        print('Reconnecting to WebSocket...');
        _connectWebSocket();
      });
    }
  }

  @override
  void dispose() {
    isConnected = false;
    channel.sink.close(status.goingAway);
    _messageController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final message = _messageController.text;
      setState(() {
        _messages.add({'message': message, 'isUser': true});
        isLoading = true; // Start showing the loading indicator
      });
      channel.sink.add(jsonEncode({'message': message, 'chat_id': 1}));
      print('Sent: $message');
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Chat with AI')),
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            unselectedLabelColor: Colors.black,
            labelColor: kHighlightedColor,
            indicatorColor: kHighlightedColor,
            controller: _tabController,
            tabs: const [
              Tab(text: 'Job Search'),
              Tab(text: 'Profile Search'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildChatScreen(),
            _buildChatScreen(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatScreen() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  // Show loading indicator
                  return Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 5.0,
                              ),
                              Image.asset(
                                'assets/images/avatars/robot.png',
                                height: 50,
                                width: 50,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const SizedBox(height: 20.0, width: 20.0, child: CircularProgressIndicator()),
                              const SizedBox(
                                width: 5.0,
                              ),
                              const Text('Generating response...'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  final message = _messages[index];
                  return MessageBubbleForJobSearch(
                    userImage: getProfilePic(),
                    message: message['message'],
                    isUser: message['isUser'],
                  );
                }
              },
            ),
          ),
          SizedBox(
            child: Row(
              children: [
                const SizedBox(width: 5),
                Material(
                  color: kPurple,
                  borderRadius: BorderRadius.circular(5.0),
                  elevation: 5.0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(5.0),
                    onTap: () {
                      refreshResponse();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 11),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/add_icon_new_topic.png',
                            height: 12,
                            width: 12,
                          ),
                          const SizedBox(width: 2),
                          const Text(
                            'New Topic',
                            style: TextStyle(fontSize: 8, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: SizedBox(
                    height: 35,
                    child: TextField(
                      controller: _messageController,
                      focusNode: _focusNode,
                      style: kTextFieldTextStyle,
                      readOnly: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: const TextStyle(color: Color(0xFF95969D), fontSize: 12),
                        hintText: 'Hello, how can I help you...',
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 10,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFF1F1F1), width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _sendMessage();
                          },
                          child: Image.asset(
                            scale: 3.0,
                            'assets/images/send.png',
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 2.0,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: speechToText.isListening ? stopListening : startListening,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: speechToText.isListening
                              ? [
                                  const BoxShadow(
                                    color: kPurple,
                                    spreadRadius: 5,
                                    blurRadius: 10,
                                  ),
                                ]
                              : [],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: speechToText.isListening
                              ? Image.asset(
                                  'assets/images/mic_gif.gif',
                                  width: 20,
                                  height: 20,
                                )
                              : Image.asset(
                                  'assets/images/mic.png',
                                  width: 20,
                                  height: 20,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _messageController.text = result.recognizedWords;
    });
  }

  void stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void startListening() async {
    if (cvObj.isNotEmpty || chatCvObj.isNotEmpty) {
      await speechToText.listen(
        onResult: (result) {
          return onSpeechResult(result);
        },
      );
      setState(() {});
    }
  }

  void refreshResponse() {
    _messages.clear();
    _messageController.clear();
    _focusNode.unfocus();
    print("Response Refreshed");
    setState(() {});
  }
}
