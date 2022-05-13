import 'package:ease_video_player/Screens/playvideos/videoplay.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../main.dart';
import 'Screenwidgets/screenwidgets.dart';

class CustomSearchDelegate extends SearchDelegate {
  late List<String> searchTerms = pathList;

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    // onlyy    movieNameLister();

    for (var movie in searchTerms) {
      if (basenameWithoutExtension(movie)
          .toLowerCase()
          .contains(query.toLowerCase())) {
        matchQuery.add(movie);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(basenameWithoutExtension(result)),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];

    for (var i = 0; i < searchTerms.length; i++) {
      if (basenameWithoutExtension(searchTerms[i])
          .toLowerCase()
          .contains(query.toLowerCase())) {
        matchQuery.add(searchTerms[i]);
      }
    }
    if (matchQuery.isNotEmpty) {
      return ListView.builder(
          itemCount: matchQuery.length,
          itemBuilder: (context, index) {
            var i = pathList.indexOf(matchQuery[index]);
            var result = matchQuery[index];
            return Column(
              children: [
                // SizedBox(height: 1,),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
                  child: ListTile(
                    leading: Container(
                      alignment: Alignment.topRight,
                      width: 97,
                      height: 57,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: thumblist.length <= i
                              ? Image.asset("asset/images/s.png").image
                              : MemoryImage(thumblist[i]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(basenameWithoutExtension(result)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VideoPlay(
                                    name: result,
                                    path: matchQuery[index],
                                  )));
                    },
                  ),
                ),
              ],
            );
          });
    } else {
      return const Center(child: Text('No Videos found'));
    }
  }
}
