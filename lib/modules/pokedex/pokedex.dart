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
  late Future<List<Pokemon>> futurePokemons;

  @override
  void initState() {
    super.initState();
    futurePokemons = fetchPokemons();
  }

  Future<List<Pokemon>> fetchPokemons() async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon'));
    return parsePokemons(response.body);
  }

  List<Pokemon> parsePokemons(String responseBody) {
    final parsed = jsonDecode(responseBody);
    return parsed["results"]
        .map<Pokemon>((json) => Pokemon.fromJson(json))
        .toList();
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
                  FutureBuilder<List<Pokemon>>(
                    future: futurePokemons,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('An error has occurred!'),
                        );
                      } else if (snapshot.hasData) {
                        return PokemonsList(pokemons: snapshot.data!);
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )
                ],
              ),
            )));
  }
}

class PokemonsList extends StatelessWidget {
  const PokemonsList({super.key, required this.pokemons});

  final List<Pokemon> pokemons;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
        ),
        itemCount: pokemons.length,
        itemBuilder: (context, index) {
          return Text(pokemons[index].name);
        },
      ),
    );
  }
}

class Pokemon {
  final String name;

  const Pokemon({required this.name});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(name: json["name"]);
  }
}
