import 'dart:convert';

import 'package:masarat/models/PostModel.dart';
import 'package:http/http.dart' as http;

class PostService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/posts';
 late List<PostModel> _allPosts;

  Future<List<PostModel>> chargerPosts() async {
    try {
      final reponse = await http.get(Uri.parse(baseUrl));

      if (reponse.statusCode == 200) {
        final List<dynamic> donnees = json.decode(reponse.body);
        return donnees.map((json) => PostModel.fromJson(json)).toList();
      } else {
        throw Exception('Échec du chargement des Posts');
      }
    } catch (e) {
      throw Exception('Une erreur s\'est produite: $e');
    }
  }

 Future<void> supprimerPost(String id) async {
  try {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Échec de la suppression du post: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Une erreur s\'est produite lors de la suppression: $e');
  }
}


  List<PostModel> filterPosts(String query) {
    if (query.isEmpty) {
      return _allPosts;
    } else {
      return _allPosts.where((post) => post.title.toLowerCase().contains(query.toLowerCase()) || post.body.toLowerCase().contains(query.toLowerCase())).toList();
    }
  }
}
