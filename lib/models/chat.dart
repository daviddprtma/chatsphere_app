import 'package:chatsphere_app/models/chat_message.dart';
import 'package:chatsphere_app/models/chat_user.dart';

class Chat {
  final String uid;
  final String currentUser;
  final bool activity;
  final bool group;
  final List<ChatUser> members;
  List<ChatMessage> messages;

  late final List<ChatUser> _recipients;

  Chat(
      {required this.uid,
      required this.currentUser,
      required this.activity,
      required this.group,
      required this.members,
      required this.messages}) {
    _recipients = members.where((member) => member.uid != currentUser).toList();
  }

  List<ChatUser> recipients() {
    return _recipients;
  }

  String title() {
    return !group
        ? _recipients.first.name
        : _recipients.map((member) => member.name).join(', ');
  }

  String imageUrl() {
    return !group
        ? _recipients.first.imageUrl
        : "https://e7.pngegg.com/pngimages/380/670/png-clipart-group-chat-logo-blue-area-text-symbol-metroui-apps-live-messenger-alt-2-blue-text.png";
  }
}
