import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;

import 'base/base.dart';

/// 生成国际化代码
void main() {
  L10nPackageModel package = L10nPackageModel.current;

  if (package.l10nFiles.isEmpty) {
    log.w('scan in `${package.srcDir.path}`, parse l10n files result is empty');
    return;
  }

  File l10nFile = File(path.join(package.genDir.path, 'l10n.gen.dart'));
  l10nFile.gen(
    ignoreForFile: const <String>{
      'constant_identifier_names',
      'prefer_single_quotes',
    },
    coder: (lb) {
      lb.directives.add(Directive.import('package:base/l10n.dart'));
      lb.body.add(
        Enum((eb) {
          eb
            ..docs.addAll([
              '/// L10n keys and translations',
              '/// ',
              '/// Has ${package.l10nMethods.length} keys',
            ])
            ..name = 'L10n'
            ..mixins.add(refer('L10nMixin'));
          eb.values.addAll(
            package.l10nMethods.values.map(
              (lmm) => EnumValue(
                (evb) => evb
                  ..docs.addAll(lmm.l10nDocs)
                  ..name = lmm.l10nKeyName,
              ),
            ),
          );
          eb.fields.add(
            Field((fb) {
              fb
                ..static = true
                ..modifier = FieldModifier.final$
                ..type = refer('Set<L10nTranslationModel>')
                ..name = 'translations';
              fb.assignment = Block((bb) {
                bb.statements.add(const Code('<L10nTranslationModel>{'));

                for (var MapEntry<String, Map<String, String>>(
                      key: String languageTag,
                      value: Map<String, String> translations,
                    )
                    in package.l10nTranslations.entries) {
                  bb.statements.add(const Code('L10nTranslationModel('));

                  bb.statements.add(Code("languageTag: '$languageTag',"));
                  bb.statements.add(const Code('translations: const {'));
                  for (var MapEntry(key: String key, value: String value)
                      in translations.entries) {
                    String symbol = "'";
                    if (value.contains(symbol)) {
                      symbol = '"';
                    }
                    if (value.contains('\n')) {
                      symbol = '$symbol$symbol$symbol';
                    }
                    bb.statements.add(Code("'$key': $symbol$value$symbol,"));
                  }
                  bb.statements.add(const Code('},'));

                  bb.statements.add(const Code('),')); // L10nTranslationModel
                }

                bb.statements.add(const Code('}')); // Set<L10nTranslationModel>
              });
            }),
          );
        }),
      );
    },
  );

  // gen xxx_l10n.gen.dart
  for (L10nFileModel file in package.l10nFiles) {
    String basename = path.basename(file.file.path);
    File mixinFile = File('${path.withoutExtension(file.file.path)}.gen.dart');
    mixinFile.gen(
      coder: (lb) {
        lb.directives.addAll(
          {
            Directive.import('package:base/l10n.dart'),
            Directive.import(package.getPackageUri(l10nFile)),
            Directive.import(basename),
            Directive.export(basename),
          }.sorted(),
        );
        lb.body.addAll(
          file.l10nClasses.map(
            (lcm) => Mixin((mib) {
              mib.docs.addAll(lcm.l10nDocs);
              mib.name = '${lcm.name}Mixin';
              mib.implements.add(refer(lcm.name));
              mib.methods.addAll(
                lcm.l10nMethods.expand(
                  (lmm) => [
                    Method(
                      (mb) => mb
                        ..docs.addAll(lmm.l10nDocs)
                        ..annotations.add(refer('override'))
                        ..returns = refer('String')
                        ..type = MethodType.getter
                        ..name = lmm.name
                        ..lambda = true
                        ..body = Code('${lmm.name}Entry.value'),
                    ),
                    Method(
                      (mb) => mb
                        ..returns = refer('String')
                        ..type = MethodType.getter
                        ..name = '${lmm.name}Key'
                        ..lambda = true
                        ..body = Code('${lmm.name}Entry.key'),
                    ),
                    Method(
                      (mb) => mb
                        ..returns = refer('L10nMixin')
                        ..type = MethodType.getter
                        ..name = '${lmm.name}Entry'
                        ..lambda = true
                        ..body = Code('L10n.${lmm.l10nKeyName}'),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
