import 'data/api_call.dart';
import 'data/characters_model.dart';
import 'data/repository.dart';
import 'logic/cubit/characters_cubit.dart';
import 'presentation/characters_screen.dart';
import 'presentation/details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoutes {
  CharactersCubit? cubit;
  Repository? repository;

  AppRoutes() {
    repository = Repository(APICall());

    cubit = CharactersCubit(repository!);
  }

  Route? generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => BlocProvider<CharactersCubit>(
                  create: (context) => cubit!,
                  child: const CharactersScreen(),
                ));
      case '/details':
        final detailedCharacter = routeSettings.arguments as CharactersModel;
        return MaterialPageRoute(
            builder: (_) => BlocProvider<CharactersCubit>(
                  create: (context) => CharactersCubit(repository!),
                  child: DetailsCharacter(
                    charactersModel: detailedCharacter,
                  ),
                ));
    }
  }
}
