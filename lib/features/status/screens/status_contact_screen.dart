import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/status/controller/status_controller.dart';
import 'package:whatsapp/features/status/screens/status_screen.dart';
import 'package:whatsapp/models/status_model.dart';

import '../../../utils/constant/app_color.dart';

class StatusContactScreen extends ConsumerWidget {
  const StatusContactScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return  FutureBuilder<List<StatusModel>>(
      future:ref.read(statusControllerProvider).getStatus(context) ,
      builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Loader();
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context,index){
            var statusData=snapshot.data![index];
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(StatusScreen.routeName,arguments: statusData,);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(
                        statusData.userName,
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          statusData.profilePic,
                        ),
                        radius: 30,
                      ),
                      // trailing: Text(
                      //   DateFormat('hh:mm a').format(statusData.createdAt),
                      //   style: const TextStyle(
                      //     color: Colors.grey,
                      //     fontSize: 13,
                      //   ),
                      // ),
                    ),
                  ),
                ),
                const Divider(color: dividerColor, indent: 85),
              ],
            );

          },);
      },
    );
  }
}
