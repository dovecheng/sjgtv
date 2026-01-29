import 'dart:io';

import 'package:collection/collection.dart';
import 'package:excel/excel.dart';

import 'base/base.dart';

/// 导出国际化表格
void main() {
  L10nPackageModel package = L10nPackageModel.current;

  if (package.l10nFiles.isEmpty) {
    log.w('scan in `${package.srcDir.path}`, parse l10n files result is empty');
    return;
  }

  // 电子表格文件
  File l10nXlsx = File('${package.dirName}_l10n.xlsx');

  // 创建或读取电子表格
  Excel excel = l10nXlsx.existsSync()
      ? Excel.decodeBytes(l10nXlsx.readAsBytesSync())
      : Excel.createExcel();

  // 设置默认工作表
  DateTime now = DateTime.now();
  String sheetName = '${now.year}-${now.month}-${now.day}';
  Sheet sheet = excel[sheetName];
  for (int i = 1; sheet.rows.isNotEmpty; i++) {
    sheetName = '${now.year}-${now.month}-${now.day}($i)';
    sheet = excel[sheetName];
  }
  excel.setDefaultSheet(sheetName);

  // 单元格样式
  CellStyle titleStyle = CellStyle(
    fontColorHex: ExcelColor.lightBlue,
    backgroundColorHex: ExcelColor.white70,
    bold: true,
    fontSize: 12,
    textWrapping: TextWrapping.WrapText,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
  );
  CellStyle contextStyle = CellStyle(
    fontColorHex: ExcelColor.black87,
    fontSize: 12,
    textWrapping: TextWrapping.WrapText,
    verticalAlign: VerticalAlign.Center,
  );

  // 添加数据到工作表
  package.l10nTable.forEachIndexed((line, row) {
    sheet.appendRow(row.map(TextCellValue.new).toList());

    // 设置单元格样式
    for (int columnIndex = 0; columnIndex < row.length; columnIndex++) {
      sheet
          .cell(
            CellIndex.indexByColumnRow(
              columnIndex: columnIndex,
              rowIndex: line,
            ),
          )
          .cellStyle = line == 0
          ? titleStyle
          : contextStyle;
    }
  });

  List<int>? bytes = excel.encode();
  if (bytes != null) {
    l10nXlsx.writeAsBytesSync(bytes);
    log.i('write file succeed, path is ${l10nXlsx.path}');
  } else {
    log.e('excel encode faulted');
  }
}
