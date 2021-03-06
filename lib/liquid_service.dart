import 'dart:async' show Future;
import 'dart:io';
import 'package:ben_n_liq_app/liquid.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class LiquidService {
  Future<String> get _localHiddenPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> get _localVisiblePath async {
    Directory _directory;
    if (Platform.isAndroid) {
      _directory = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      _directory = await getApplicationDocumentsDirectory();
    }
    return _directory.path;
  }

  Future<File> get _localHiddenFile async {
    final _path = await _localHiddenPath;
    return File('$_path/liquids.json');
  }

  Future<File> get _localVisibleFile async {
    final _path = await _localVisiblePath;
    if (Platform.isAndroid) {
      if (!(await Directory('$_path/BenNLiq').exists())) {
        new Directory('$_path/BenNLiq').create();
      }
      return File('$_path/BenNLiq/liquids.json');
    }
    return File('$_path/liquids.json');
  }

  Future<List<Liquid>> loadLiquidsDirectory() async {
    print('Begining to load liquidsDirectory');
    File file = await _localHiddenFile;
    List<dynamic> jsonResponse = jsonDecode(await file.readAsString());
    List<Liquid> liquids = jsonResponse.map((i) => Liquid.fromJson(i)).toList();
    print('Finish to load liquidsDirectory');
    return liquids;
  }

  Future saveLiquids(List<Liquid> liquids) async {
    print('Begining to save liquids');
    String liquidsEncode = jsonEncode(liquids);
    final file = await _localHiddenFile;
    file.writeAsString(liquidsEncode);
    print('Finish to save liquids');
  }

  Future<List<Liquid>> loadVisibleLiquidsDirectory() async {
    print('Begining to load visible directory');
    File file = await _localVisibleFile;
    List<dynamic> jsonResponse = jsonDecode(await file.readAsString());
    List<Liquid> liquids = jsonResponse.map((i) => Liquid.fromJson(i)).toList();
    print('Finish to load visible directory');
    return liquids;
  }

  Future saveVisibleLiquids(List<Liquid> liquids) async {
    print('Begining to save visible liquids');
    String liquidsEncode = jsonEncode(liquids);
    final file = await _localVisibleFile;
    file.writeAsString(liquidsEncode);
    print('Finish to save visible liquids');
  }
}
