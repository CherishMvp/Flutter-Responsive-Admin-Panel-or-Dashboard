import 'package:com.cherish.admin/controllers/fridge_controller.dart';
import 'package:com.cherish.admin/generated/l10n.dart';
import 'package:com.cherish.admin/models/food_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class RecentFoods extends StatelessWidget {
  const RecentFoods({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).recent_food,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: Provider.of<FridgeProvider>(context)
                    .getFridgeFoods('1')
                    .isNotEmpty
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: defaultPadding,
                      horizontalMargin: 15,
                      // minWidth: 600,
                      columns: [
                        DataColumn(
                          label: Text("Food Name"),
                          tooltip: "Food Name",
                        ),
                        DataColumn(
                          label: Text("Purchase Date"),
                        ),
                        DataColumn(
                          label: Text("Expiry Date"),
                        ),
                      ],
                      rows: List.generate(
                        context
                            .read<FridgeProvider>()
                            .getFridgeFoods('1')
                            .length,
                        (index) => recentFoodsDataRow(context
                            .read<FridgeProvider>()
                            .getFridgeFoods('1')[index]),
                      ),
                    ))
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: SvgPicture.asset(
                        width: 150,
                        height: 150,
                        'assets/icons/undraw_empty_re_opql.svg',
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

DataRow recentFoodsDataRow(FoodItem fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/doc_file.svg',
              height: 30,
              width: 30,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 140),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                  fileInfo.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
      DataCell(Text(
          DateFormat('yyyy-MM-dd', 'zh_CN').format(fileInfo.purchaseDate))),
      DataCell(
          Text(DateFormat('yyyy-MM-dd', 'zh_CN').format(fileInfo.expiryDate))),
    ],
  );
}
