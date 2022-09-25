import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

import '../models/category_model/category_model.dart';
import '../models/transaction_model/transaction_model.dart';

class CatAndTranInitialize {
  void initializeTransAndCat() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
      Hive.registerAdapter(CategoryModelAdapter());
    }
    if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
      Hive.registerAdapter(CategoryTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
      Hive.registerAdapter(TransactionModelAdapter());
    }
  }
}
