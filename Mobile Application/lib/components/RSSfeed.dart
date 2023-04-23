import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthy_kid_app/components/Detailscreen.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;

class RSSFeed extends StatefulWidget {
  const RSSFeed({super.key, required this.title});
  final String title;
  @override
  State<RSSFeed> createState() => _RSSFeedState();
}

class _RSSFeedState extends State<RSSFeed> {
  final Xml2Json xml2json = Xml2Json();
  List TopStories = [];
  Future NewsTopStories() async {
    final url = Uri.parse('https://feeds.feedburner.com/ndtvcooks-latest');
    final response = await http.get(url);
    xml2json.parse(response.body.toString());
    var jsondata = await xml2json.toGData();
    var data = json.decode(jsondata);
    TopStories = data['rss']['channel']['item'];
    print(TopStories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 205, 130),
      ),
      body: Center(
        child: FutureBuilder(
          future: NewsTopStories(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? Container(
                    height: 45,
                    width: 45,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.75,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Text(
                            'Top Practices for you',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          controller: ScrollController(),
                          itemCount: TopStories.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2,
                                      spreadRadius: 2,
                                      color: Colors.black12,
                                    )
                                  ]),
                              child: ListTile(
                                onTap: (() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return detailscreen(
                                          title: TopStories[index]['title']
                                              ['__cdata'],
                                          imagedata: TopStories[index]
                                              ['media\$content']['url'],
                                          decription: TopStories[index]
                                              ['description']['__cdata'],
                                          date: TopStories[index]['pubDate']
                                              ['__cdata'],
                                        );
                                      },
                                    ),
                                  );
                                }),
                                horizontalTitleGap: 10,
                                minVerticalPadding: 10,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                title: Text(
                                  TopStories[index]['title']['__cdata'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                leading: Image.network(
                                  TopStories[index]['media\$content']['url'],
                                  fit: BoxFit.cover,
                                  height: 80,
                                  width: 80,
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
