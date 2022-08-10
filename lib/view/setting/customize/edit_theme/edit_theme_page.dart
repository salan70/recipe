import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../../../domain/type_adapter/customizations/customizations.dart';
import 'edit_theme_model.dart';

class EditThemePage extends ConsumerWidget {
  const EditThemePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editThemeModel = EditThemeModel();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'テーマを変更',
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: CustomizationsBoxes.getCustomizations().listenable(),
        builder: (context, box, widget) {
          final usedSchemeIndex = editThemeModel.fetchSelectedFlexSchemeIndex();
          final usedThemeModeIndex =
              editThemeModel.fetchSelectedThemeModeIndex();

          final themeMode =
              editThemeModel.themeModeList[usedThemeModeIndex].themeMode;

          return SettingsList(
            sections: [
              SettingsSection(
                title: const Text('テーマモード'),
                tiles: [
                  for (int index = 0;
                      index < editThemeModel.themeModeList.length;
                      index++)
                    index == usedThemeModeIndex
                        ? SettingsTile(
                            title: Text(
                              editThemeModel.themeModeList[index].themeModeName,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            trailing: Icon(
                              Icons.check_rounded,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        : SettingsTile(
                            title: Text(
                              editThemeModel.themeModeList[index].themeModeName,
                            ),
                            onPressed: (context) {
                              editThemeModel.editSelectedThemeModeIndex(index);
                            },
                          ),
                ],
              ),
              SettingsSection(
                title: const Text('テーマカラー'),
                tiles: [
                  for (var flexScheme in editThemeModel.flexSchemeList)
                    flexScheme.index == usedSchemeIndex
                        ? SettingsTile(
                            title: _settingFlexSchemeTileTitle(
                              context,
                              themeMode,
                              flexScheme,
                              true,
                            ),
                            trailing: Icon(
                              Icons.check_rounded,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        : SettingsTile(
                            title: _settingFlexSchemeTileTitle(
                              context,
                              themeMode,
                              flexScheme,
                              false,
                            ),
                            onPressed: (context) {
                              editThemeModel.editSelectedFlexSchemeIndex(
                                flexScheme.index,
                              );
                            },
                          )
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Row _settingFlexSchemeTileTitle(
    BuildContext context,
    ThemeMode themeMode,
    FlexScheme flexScheme,
    bool isUsed,
  ) {
    final brightness = Theme.of(context).brightness;
    return Row(
      children: [
        Container(
          width: 24.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: brightness == Brightness.light
                ? FlexThemeData.light(scheme: flexScheme).primaryColor
                : FlexThemeData.dark(scheme: flexScheme).primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: 4.w,
        ),
        Container(
          width: 24.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: brightness == Brightness.light
                ? FlexThemeData.light(scheme: flexScheme).primaryColorDark
                : FlexThemeData.dark(scheme: flexScheme).primaryColorDark,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: 4.w,
        ),
        Container(
          width: 24.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: brightness == Brightness.light
                ? FlexThemeData.light(scheme: flexScheme).colorScheme.secondary
                : FlexThemeData.dark(scheme: flexScheme).colorScheme.secondary,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: 8.w,
        ),
        Text(
          flexScheme.name,
          style: isUsed == true
              ? TextStyle(
                  color: brightness == Brightness.light
                      ? FlexThemeData.light(scheme: flexScheme)
                          .colorScheme
                          .secondary
                      : FlexThemeData.dark(scheme: flexScheme)
                          .colorScheme
                          .secondary,
                )
              : null,
        ),
      ],
    );
  }
}
