import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import '../data/characters_model.dart';
import '../data/quote.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/cubit/characters_cubit.dart';

class DetailsCharacter extends StatelessWidget {
  CharactersModel charactersModel;
  DetailsCharacter({Key? key, required this.charactersModel}) : super(key: key);

  Widget characterInfo(String title, String desc) {
    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      text: TextSpan(children: [
        TextSpan(
          text: title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5),
        ),
        TextSpan(
          text: desc,
          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15.5),
        )
      ]),
    );
  }

  Widget buildDivider(double height) {
    return Divider(
      height: 30,
      endIndent: height,
      color: Colors.black45,
      thickness: 2,
    );
  }

  Widget sliverAppBar() {
    return SliverAppBar(
      expandedHeight: 600,
      leadingWidth: double.infinity,
      pinned: true,
      stretch: true,
      backgroundColor: Color(0xffa30000),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          charactersModel.name!,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Color(0xffe0e0e0),
              fontFamily: "DarkerGrotesque-Regular",
              fontWeight: FontWeight.bold),
        ),
        background: Hero(
          tag: charactersModel.charId!,
          child: FadeInImage(
            placeholder: AssetImage('assets/images/loading_4.gif'),
            image: NetworkImage(charactersModel.img!),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget checkQuotesStatus(CharactersState state) {
    if (state is QuotesLoaded) {
      return quoteBuilder(state);
    } else {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.red[800],
          color: Colors.black45,
        ),
      );
    }
  }

  Widget quoteBuilder(state) {
    List<Quote> quotes = (state).quotes;

    if (quotes.isNotEmpty) {
      int randomIndex = Random().nextInt(quotes.length);

      return Center(
        child: SizedBox(
          width: 250.0,
          child: DefaultTextStyle(
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 7.0,
                  color: Colors.white,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                FlickerAnimatedText(quotes[randomIndex].characterQuote),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharactersCubit>(context).getQuotes(charactersModel.name!);
    return Scaffold(
      backgroundColor: Color(0xffa30000),
      body: CustomScrollView(
        slivers: [
          sliverAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: EdgeInsets.fromLTRB(14, 14, 14, 0),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      characterInfo("Nick Name: ", charactersModel.nickname!),
                      buildDivider(200),
                      characterInfo("BirthDay: ", charactersModel.birthday!),
                      buildDivider(200),
                      characterInfo(
                          "Dead Or Alive: ", charactersModel.status.toString()),
                      buildDivider(150),
                      characterInfo("Actor Name: ", charactersModel.portrayed!),
                      buildDivider(105),
                      characterInfo(
                          "Breaking Bad Seasons: ",
                          charactersModel.appearance!.isNotEmpty
                              ? charactersModel.appearance!.join(' / ')
                              : "Didn't Appear in Breaking Bad"),
                      buildDivider(120),
                      characterInfo(
                          "Better Call Saul Seasons: ",
                          charactersModel.betterCallSaulAppearance!.isNotEmpty
                              ? charactersModel.betterCallSaulAppearance!
                                  .join(' / ')
                              : "Didn't Appear in Better Call Saul"),
                      buildDivider(120),
                      BlocBuilder<CharactersCubit, CharactersState>(
                        builder: (context, state) {
                          return checkQuotesStatus(state);
                        },
                      ),
                      const SizedBox(
                        height: 600,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
