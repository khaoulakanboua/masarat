import 'package:flutter/material.dart';
import 'package:masarat/models/PostModel.dart';
import 'package:masarat/services/PostService.dart';
import 'package:masarat/ui/PostDetails.dart';

class PostListWidget extends StatefulWidget {
  @override
  _PostListWidgetState createState() => _PostListWidgetState();
}

class _PostListWidgetState extends State<PostListWidget> {
  final PostService _postService = PostService();
  late Future<List<PostModel>> _postListFuture;
  TextEditingController _searchController = TextEditingController();
  List<PostModel> _allPosts = [];
  List<PostModel> _visiblePosts = [];
  int _currentPage = 0;
  int _postsPerPage = 8;

  @override
  void initState() {
    super.initState();
    _postListFuture = _postService.chargerPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                _filterPosts(value);
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<PostModel>>(
              future: _postListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Une erreur s\'est produite: ${snapshot.error}'));
                } else {
                  _allPosts = snapshot.data!;
                  _visiblePosts = _allPosts.sublist(_currentPage * _postsPerPage, (_currentPage + 1) * _postsPerPage);
                  return ListView.builder(
                    itemCount: _visiblePosts.length,
                    itemBuilder: (context, index) {
                      final post = _visiblePosts[index];
                      return Card(
                        child: ListTile(
                          title: Text(post.title),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostDetailsScreen(post: post),
                              ),
                            );
                          },
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deletePost(post),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _currentPage == 0 ? null : () => setState(() => _currentPage--),
                color: _currentPage == 0 ? Colors.grey : Colors.blue, 
              ),
              SizedBox(width: 20),
              Text(
                '${_currentPage + 1} / ${(_allPosts.length / _postsPerPage).ceil()}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(width: 20),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _currentPage >= (_allPosts.length / _postsPerPage).ceil() - 1
                    ? null
                    : () => setState(() => _currentPage++),
                color: _currentPage >= (_allPosts.length / _postsPerPage).ceil() - 1
                    ? Colors.grey
                    : Colors.blue, 
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

 void _filterPosts(String query) {
  setState(() {
    _visiblePosts = _allPosts.where((post) {
      final titleLower = post.title.toLowerCase();
      final bodyLower = post.body.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) || bodyLower.contains(searchLower);
    }).toList();
    _currentPage = 0;
    _updateVisiblePosts();
  });
}

void _updateVisiblePosts() {
  final int end = (_currentPage + 1) * _postsPerPage;
  if (end > _visiblePosts.length) {
    _visiblePosts = _visiblePosts.sublist(_currentPage * _postsPerPage);
  } else {
    _visiblePosts = _visiblePosts.sublist(_currentPage * _postsPerPage, end);
  }
}


  void _deletePost(PostModel post) {
    setState(() {
      _allPosts.remove(post);
      _visiblePosts.remove(post);
    });
    _postService.supprimerPost(post.id.toString());
  }
}
