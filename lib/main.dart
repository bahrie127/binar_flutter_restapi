import 'package:binar_restapi_http/network_manager.dart';
import 'package:flutter/material.dart';

import 'album.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureAlbum = NetworkManager().fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Binar Flutter REST API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('http example')),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              // If the connection is done,
              // check for response data or an error.
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(snapshot.data!.title.isEmpty
                          ? 'Deleted'
                          : snapshot.data!.title),
                      ElevatedButton(
                        child: const Text('Delete Data'),
                        onPressed: () {
                          setState(() {
                            futureAlbum = NetworkManager()
                                .deleteAlbum(snapshot.data!.id.toString());
                          });
                        },
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
        // body: Column(
        //   children: [
        //     // Column(
        //     //   mainAxisAlignment: MainAxisAlignment.center,
        //     //   children: <Widget>[
        //     //     TextField(
        //     //       controller: _controller,
        //     //       decoration: const InputDecoration(hintText: 'Enter Title'),
        //     //     ),
        //     //     ElevatedButton(
        //     //       onPressed: () {
        //     //         setState(() {
        //     //           futureAlbum =
        //     //               NetworkManager().createAlbum(_controller.text);
        //     //         });
        //     //       },
        //     //       child: const Text('Create Data'),
        //     //     ),
        //     //   ],
        //     // ),
        //     Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: <Widget>[
        //         Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: TextField(
        //             controller: _controller,
        //             decoration: const InputDecoration(hintText: 'Enter Title'),
        //           ),
        //         ),
        //         ElevatedButton(
        //           onPressed: () {
        //             setState(() {
        //               futureAlbum =
        //                   NetworkManager().updateAlbum(1, _controller.text);
        //             });
        //           },
        //           child: const Text('Update Data'),
        //         ),
        //       ],
        //     ),
        //     FutureBuilder<Album>(
        //       future: futureAlbum,
        //       builder: (context, snapshot) {
        //         if (snapshot.hasData) {
        //           return Center(child: Text(snapshot.data!.title));
        //         } else if (snapshot.hasError) {
        //           return Text('${snapshot.error}');
        //         }
        //         return const CircularProgressIndicator();
        //       },
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
