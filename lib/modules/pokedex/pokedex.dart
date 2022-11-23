import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:http/http.dart' as http;

class PokedexPage extends StatefulWidget {
  const PokedexPage({super.key});

  @override
  State<PokedexPage> createState() => _PokedexPageState();
}

class _PokedexPageState extends State<PokedexPage> {
  late Future<Pokemon> futurePokemon;

  @override
  void initState() {
    super.initState();
    futurePokemon = fetchPokemons();
  }

  Future<Pokemon> fetchPokemons() async {
    final response =
        await http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon/1"));

    if (response.statusCode == 200) {
      return Pokemon.fromJson(jsonDecode(response.body));
    } else {
      print('There was an error tryisng to fetch the pokemons');
      throw Exception('There was an error trying to fetch the pokemons');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
        color: Colors.white,
        child: DefaultTextStyle(
            style: const TextStyle(
                decoration: TextDecoration.none, color: Colors.black87),
            child: Padding(
              padding: const EdgeInsets.only(top: 56, left: 32, right: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pokedex",
                    style: TextStyle(fontSize: 22, color: Colors.black87),
                  ),
                  FutureBuilder<Pokemon>(
                    future: futurePokemon,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data!.name);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      // By default, show a loading spinner.
                      return const CircularProgressIndicator();
                    },
                  )
                ],
              ),
            )));
  }
}

class Pokemon {
  final String name;

  const Pokemon({required this.name});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(name: json["name"]);
  }
}

class List extends StatelessWidget {
  const List({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
