import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:recipe/domain/type_adapter/ingredient_unit/ingredient_unit.dart';
import 'package:recipe/domain/type_adapter/selected_flex_scheme_index/selected_flex_scheme_index.dart';
import 'package:recipe/view/other/edit_ingredient_unit/edit_ingredient_unit_model.dart';
import 'package:recipe/view/setting/customize/edit_theme_color/edit_theme_color_model.dart';
import 'package:settings_ui/settings_ui.dart';

class EditThemeColorPage extends ConsumerWidget {
  const EditThemeColorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                          title: _settingTileTitle(flexScheme, true),
                          trailing: Icon(
                            Icons.check_rounded,
                            color: Theme.of(context).primaryColor,
                          ))
                      : SettingsTile(
                          title: _settingTileTitle(flexScheme, false),
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

  Row _settingTileTitle(FlexScheme flexScheme, bool isUsed) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: FlexThemeData.light(scheme: flexScheme).primaryColor,
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
            color: FlexThemeData.light(scheme: flexScheme).primaryColorDark,
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
            color:
                FlexThemeData.light(scheme: flexScheme).colorScheme.secondary,
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
