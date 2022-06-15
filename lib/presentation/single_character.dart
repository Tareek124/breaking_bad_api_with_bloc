// ignore_for_file: sort_child_properties_last

import 'package:bloc_breaking_bad/data/characters_model.dart';
import 'package:flutter/material.dart';

class SingleCharacter extends StatelessWidget {
  const SingleCharacter({Key? key, required this.charactersModel})
      : super(key: key);

  final CharactersModel charactersModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: charactersModel.img!.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/details',
                    arguments: charactersModel);
              },
              child: Hero(
                tag: charactersModel.charId!,
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsetsDirectional.all(7),
                    margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                    decoration: BoxDecoration(
                        color: const Color(0xffe0e0e0),
                        borderRadius: BorderRadius.circular(12)),
                    child: GridTile(
                      child: Container(
                        color: Colors.grey,
                        child: FadeInImage(
                          placeholder:
                              const AssetImage("assets/images/loading_4.gif"),
                          image: NetworkImage(charactersModel.img!),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      footer: Container(
                          color: Colors.black54,
                          child: Text(
                            charactersModel.name!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontFamily: "DarkerGrotesque-Regular",
                                color: Color(0xffe0e0e0),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )),
                    )),
              ),
            ),
    );
  }
}
