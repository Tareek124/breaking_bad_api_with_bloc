import '../data/characters_model.dart';
import '../logic/cubit/characters_cubit.dart';
import 'single_character.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  List<CharactersModel> characters = [];
  List<CharactersModel> searchedCharacter = [];

  var controller = TextEditingController();

  bool isSearching = false;

  Widget searchingTextField() {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide.none),
        hintText: "Search For Character",
        hintStyle: TextStyle(
            fontFamily: "DarkerGrotesque-Regular",
            color: Color(0xffe0e0e0),
            fontWeight: FontWeight.bold,
            fontSize: 19),
      ),
      style: const TextStyle(
          fontFamily: "DarkerGrotesque-Regular",
          color: Color(0xffe0e0e0),
          fontWeight: FontWeight.bold,
          fontSize: 19),
      onChanged: (char) {
        getSearchedCharacters(char);
        setState(() {});
      },
    );
  }

//this will filter the character list depending on the searching-------------------:-
  getSearchedCharacters(String searchingChar) {
    searchedCharacter = characters
        .where((character) =>
            character.name!.toLowerCase().startsWith(searchingChar))
        .toList();
  }

//actions in appBar
  List<Widget> appBarActions() {
    if (isSearching) {
      return [
        IconButton(
            onPressed: () {
              cancelSearching();
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.clear,
              color: Color(0xffe0e0e0),
            ))
      ];
    } else {
      return [
        IconButton(
            onPressed: _startSearch,
            icon: const Icon(
              Icons.search,
              color: Color(0xffe0e0e0),
            ))
      ];
    }
  }

//setting the searching widgets------------------:-
  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      isSearching = true;
    });
  }

  void _stopSearching() {
    cancelSearching();

    setState(() {
      isSearching = false;
    });
  }

  void cancelSearching() {
    setState(() {
      controller.clear();
    });
  }

//this will activate the getCharacters method when the program start----------------
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

//the blocBuilder-------------
  Widget buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
        builder: (context, state) {
      if (state is CharactersLoaded) {
        characters = (state).characters!;
        return _buildGridView();
      } else {
        return Center(
          child: Image.asset("assets/images/loading_4.gif"),
        );
      }
    });
  }

//this will build the grid view for the characters-------------
  Widget _buildGridView() {
    return SingleChildScrollView(
      child: Container(
          color: const Color(0xfff4511e),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              GridView.builder(
                  itemCount: controller.text.isEmpty
                      ? characters.length
                      : searchedCharacter.length,
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                  ),
                  itemBuilder: (context, index) {
                    return SingleCharacter(
                        charactersModel: controller.text.isEmpty
                            ? characters[index]
                            : searchedCharacter[index]);
                  }),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xffa30000),
        title: isSearching
            ? searchingTextField()
            : const Text(
                "Breaking Bad Characters",
                style: TextStyle(
                    color: Color(0xffe0e0e0),
                    fontWeight: FontWeight.bold,
                    fontFamily: "DarkerGrotesque-Regular",
                    fontSize: 22),
              ),
        actions: appBarActions(),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;

          return connected == true
              ? buildBlocWidget()
              : Center(
                  child: Container(
                    color: Colors.red[300],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset('assets/images/offline.png'),
                        const Text(
                          "Check Your NetWork",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              fontFamily: "DarkerGrotesque-Regular"),
                        ),
                      ],
                    ),
                  ),
                );
        },
        builder: (context) {
          return buildBlocWidget();
        },
      ),

      // body: buildBlocWidget(),
    );
  }
}
