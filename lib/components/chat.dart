import 'package:flutter/material.dart';
import 'package:just_chat/components/size_config.dart';
import 'package:just_chat/pages/chat_screen.dart';

import 'colors.dart';

class Chat extends StatelessWidget {
  final String peerId;
  final String peerAvatar;
  final String name;

  Chat({Key key, this.peerId, this.peerAvatar, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: SizeConfig.blockWidth * 10,
        leading: Container(
          // color: COLORS.green,
          // width: SizeConfig.blockWidth * 12,
          child: IconButton(
            iconSize: SizeConfig.blockWidth * 4,
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pushNamed(context, '/home'),
          ),
        ),
        titleSpacing: 0,
        title: Row(children: [
          CircleAvatar(
            backgroundImage: NetworkImage(peerAvatar),
            //     child: Image.network(
            //   peerAvatar,
            //   isAntiAlias: true,
            //   fit: BoxFit.cover,
            //   width: SizeConfig.blockWidth * 12,
            //   height: SizeConfig.blockWidth * 12,
            //   loadingBuilder: (BuildContext context, Widget child,
            //       ImageChunkEvent loadingProgress) {
            //     if (loadingProgress == null) return child;
            //     return Container(
            //       width: 50,
            //       height: 50,
            //       child: Center(
            //         child: CircularProgressIndicator(
            //           color: COLORS.red,
            //           value: loadingProgress.expectedTotalBytes != null &&
            //                   loadingProgress.expectedTotalBytes != null
            //               ? loadingProgress.cumulativeBytesLoaded /
            //                   loadingProgress.expectedTotalBytes
            //               : null,
            //         ),
            //       ),
            //     );
            //   },
            //   errorBuilder: (context, object, stackTrace) {
            //     return Icon(
            //       Icons.account_circle,
            //       size: 50.0,
            //       color: COLORS.greyLight,
            //     );
            //   },
            // )
          ),
          SizedBox(width: SizeConfig.blockWidth * 3),
          Text(
            '$name',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ]),
        // centerTitle: true,
      ),
      body: ChatScreen(
        peerId: peerId,
        peerAvatar: peerAvatar,
      ),
    );
  }
}
