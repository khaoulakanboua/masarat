import 'package:flutter/material.dart';
import 'package:masarat/models/PostModel.dart';

class PostDetailsScreen extends StatelessWidget {
  final PostModel post;

  const PostDetailsScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détails de Post ${post.id}"),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 8),
            Text(
              post.title,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            SizedBox(height: 20),
            Text(
              'Body:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 8),
            Text(
              post.body,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            SizedBox(height: 20),
            Text(
              'Count Number:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 8),
             Text('Word Count: ${post.getWord()}',
             style: TextStyle(fontSize: 20, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
