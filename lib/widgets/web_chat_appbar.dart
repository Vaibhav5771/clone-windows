import 'package:flutter/material.dart';
import 'package:chats_windows/colors.dart';

import '../info.dart';

class WebChatAppbar extends StatelessWidget {
  const WebChatAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.077,
      width: MediaQuery.of(context).size.width * 0.75,
      padding: const EdgeInsets.all(10),
      color: webAppBarColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://upload.wikimedia.org/wikipedia/commons/8/85/Elon_Musk_Royal_Society_%28crop1%29.jpg',
                ),
                radius: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
              Text(
                info[0]['name'].toString(),
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(onPressed: (){}, icon: Icon(Icons.search, color: Colors.black),),
              IconButton(onPressed: (){}, icon: Icon(Icons.more_vert, color: Colors.black),),
            ],
          )
        ],
      ),
    );
  }
}
