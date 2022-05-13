import 'package:ease_video_player/Screens/screen_functions/Screenwidgets/screenwidgets.dart';
import 'package:flutter/material.dart';

class WatchHistory extends StatelessWidget {
  const WatchHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xff585D67), Color(0xff233F78)]),
          ),
        ),
        automaticallyImplyLeading: true,
        title: const Text('History'),
        leading: IconButton(
            onPressed: () {
              int count = 0;
              Navigator.of(context).popUntil((_) => count++ >= 2);
            },
            icon: const Icon(Icons.arrow_back_outlined)),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                  onPressed: () {
                    historyclear(context);
                  },
                  icon: const Icon(Icons.auto_delete_outlined)))
        ],
      ),
      body: listhistoryvideos(count: 15),
    );
  }
}
