import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../common/widgets/loader.dart';
import '../../../models/chat_contact.dart';
import '../../../utils/constant/app_color.dart';
import '../controller/chat_controller.dart';
import '../screens/mobile_chat.dart';
class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<List<ChatContact>>(
        stream: ref.watch(chatControllerProvider).chatContact(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }

            final List<ChatContact>? contactList = snapshot.data;

            if (contactList == null || contactList.isEmpty) {
              return const SizedBox();
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final chatContactData = contactList[index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(MobileChatScreen.routeName, arguments: {
                          'name': chatContactData.name,
                          'uid': chatContactData.contactId,
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(
                            chatContactData.name,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              chatContactData.lastMessage,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              chatContactData.profilePic,
                            ),
                            radius: 30,
                          ),
                          trailing: Text(
                            DateFormat('hh:mm a').format(chatContactData.timeSent),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(color: dividerColor, indent: 85),
                  ],
                );
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

