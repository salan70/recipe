import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:recipe/domain/recipe.dart';
import 'package:recipe/state/procedure_list/procedure_list_provider.dart';
import 'package:recipe/state/other_provider/providers.dart';

class ProcedureTextFieldWidget extends ConsumerWidget {
  const ProcedureTextFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final procedureList = ref.watch(procedureListNotifierProvider);
    final procedureListNotifier =
        ref.watch(procedureListNotifierProvider.notifier);

    final contentIsChanged = ref.watch(contentIsChangedProvider);
    final contentIsChangedNotifier =
        ref.watch(contentIsChangedProvider.notifier);

    return Column(
      children: [
        Builder(builder: (context) {
          return ReorderableListView(
            onReorder: (oldIndex, newIndex) =>
                procedureListNotifier.reorder(oldIndex, newIndex),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              for (int index = 0; index < procedureList.length; index++)
                Slidable(
                  key: ValueKey(procedureList[index].id),
                  endActionPane: ActionPane(
                    extentRatio: 0.3,
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                          label: '削除',
                          backgroundColor: Theme.of(context).errorColor,
                          onPressed: (context) {
                            procedureListNotifier
                                .remove(procedureList[index].id!);
                          })
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(fontSize: 16.sp),
                          )),
                      Expanded(
                          flex: 15,
                          child: TextField(
                            controller: contentIsChanged == false
                                ? TextEditingController(
                                    text: procedureList[index].content)
                                : null,
                            maxLength: 100,
                            maxLines: null,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 4, top: 16, bottom: 4)
                                      .r,
                              isDense: true,
                            ),
                            onChanged: (String value) {
                              procedureList[index] = Procedure(
                                  id: procedureList[index].id, content: value);
                              contentIsChangedNotifier.update((state) => true);
                            },
                          )),
                      Icon(Icons.drag_handle),
                    ],
                  ),
                ),
            ],
          );
        }),
        TextButton(
          onPressed: () {
            String id = Uuid().v4();
            final Procedure procedures = Procedure(id: id, content: '');
            if (!procedureListNotifier.add(procedures)) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('登録できる手順は30個までです。'),
                    actions: [
                      TextButton(
                        child: Text('閉じる'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: Text('追加'),
        )
      ],
    );
  }
}
