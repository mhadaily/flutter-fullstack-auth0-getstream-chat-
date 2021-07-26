import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mjcoffee/models/auth0_permissions.dart';
import 'package:mjcoffee/models/auth0_user.dart';
import 'package:mjcoffee/services/auth_service.dart';
import 'package:mjcoffee/services/chat_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class SupportChatScreen extends StatefulWidget {
  @override
  _SupportChatScreenState createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  Auth0User? profile = AuthService.instance.profile;
  Channel? channel;

  @override
  void initState() {
    super.initState();
    createChannel();
  }

  createChannel() async {
    if (profile != null) {
      final _channel = await ChatService.instance.createSupportChat(
        profile!.availableAgents,
      );
      setState(() {
        channel = _channel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return channel == null
        ? Center(
            child: Text('You are int he queue!, please wait...'),
          )
        : Scaffold(
            body: SafeArea(
              child: StreamChannel(
                channel: channel!,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: MessageListView(),
                    ),
                    MessageInput(
                      disableAttachments: !profile!.can(UserPermissions.upload),
                      sendButtonLocation: SendButtonLocation.inside,
                      actionsLocation: ActionsLocation.leftInside,
                      showCommandsButton: !profile?.isCustomer,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
