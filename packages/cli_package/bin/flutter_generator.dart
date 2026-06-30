import 'package:flutter_generator_cli/commands/create_project.dart';
import 'package:flutter_generator_cli/commands/make_feature.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Comandos disponibles: create, make:feature');
    return;
  }

  switch (args.first) {
    case 'create':
      CreateProjectCommand().run(args.sublist(1));
      break;

    case 'make:feature':
      MakeFeatureCommand().run(args.sublist(1));
      break;

    default:
      print('Comando no reconocido');
  }
}
