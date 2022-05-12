import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:recipe/domain/type_adapter/selected_flex_scheme_index/selected_flex_scheme_index.dart';
import 'package:recipe/view/setting/customize/edit_theme_color/edit_theme_color_model.dart';
import 'package:settings_ui/settings_ui.dart';

class EditThemeColorPage extends ConsumerWidget {
  const EditThemeColorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeMode themeMode = ThemeMode.system;
    EditThemeColorModel editThemeColorModel = EditThemeColorModel();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'テーマカラーを変更',
        ),
      ),
      body: ValueListenableBuilder(
          valueListenable:
              SelectedFlexSchemeIndexBoxes.getSelectedFlexSchemeIndex()
                  .listenable(),
          builder: (context, Box box, widget) {
            int usedSchemeIndex =
                editThemeColorModel.fetchSelectedFlexSchemeIndex();

            return SettingsList(sections: [
              SettingsSection(title: Text('テーマカラー'), tiles: [
                for (var flexScheme in editThemeColorModel.flexSchemeList)
                  flexScheme.index == usedSchemeIndex
                      ? SettingsTile(
                          title: _settingTileTitle(
                              context, themeMode, flexScheme, true),
                          trailing: Icon(
                            Icons.check_rounded,
                            color: Theme.of(context).primaryColor,
                          ))
                      : SettingsTile(
                          title: _settingTileTitle(
                              context, themeMode, flexScheme, false),
                          onPressed: (context) {
                            editThemeColorModel
                                .editSelectedFlexScheme(flexScheme.index);
                          },
                        )
              ]),
            ]);
          }),
    );
  }

  Row _settingTileTitle(BuildContext context, ThemeMode themeMode,
      FlexScheme flexScheme, bool isUsed) {
    final brightness = Theme.of(context).brightness;
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: brightness == Brightness.light
                ? FlexThemeData.light(scheme: flexScheme).primaryColor
                : FlexThemeData.dark(scheme: flexScheme).primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: 4,
        ),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: brightness == Brightness.light
                ? FlexThemeData.light(scheme: flexScheme).primaryColorDark
                : FlexThemeData.dark(scheme: flexScheme).primaryColorDark,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: 4,
        ),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: brightness == Brightness.light
                ? FlexThemeData.light(scheme: flexScheme).colorScheme.secondary
                : FlexThemeData.dark(scheme: flexScheme).colorScheme.secondary,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          flexScheme.name,
          style: isUsed == true
              ? TextStyle(
                  color: FlexThemeData.light(scheme: flexScheme).primaryColor)
              : null,
        ),
      ],
    );
  }
}
