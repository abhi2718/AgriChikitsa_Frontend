import 'dart:io';

import 'package:agriChikitsa/model/jankari_subcategory_post_model.dart';
import 'package:agriChikitsa/repository/jankari.repo/jankari_repository.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../../model/jankari_card_modal.dart';
import '../../../model/jankari_subcategory_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class JankariViewModel with ChangeNotifier {
  final _jankariRepository = JankariRepository();
  List<JankariCategoryModal> jankaricardList = [];
  List<JankariSubCategoryModel> jankariSubcategoryList = [];
  List<JankariSubCategoryPostModel> jankariSubcategoryPostList = [];
  var _loading = true;
  var jankariSubCategoryLoader = false;
  var jankariSubCategoryPostLoader = false;
  var selectedCategory = "";
  var selectedSubCategory = "";
  var showSubCategoryModal = false;
  int currentPostIndex = 0;
  bool showActiveButton = false;
  bool get loading {
    return _loading;
  }

  changeActiveButtonState(bool value) {
    showActiveButton = value;
    notifyListeners();
  }

  updateCurrentPostIndex(int index) {
    if (index >= 0 && index < jankariSubcategoryPostList.length) {
      currentPostIndex = index;
    } else {
      currentPostIndex = 0;
    }
    notifyListeners();
  }

  setActiveState(BuildContext context, var category) {
    selectedCategory = category.id;
    notifyListeners();
    getJankariSubCategory(context, selectedCategory);
  }

  setloading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setJankariSubCategoryLoader(bool state) {
    jankariSubCategoryLoader = state;
    notifyListeners();
  }

  void setJankariSubCategoryLoaderPost(bool state) {
    jankariSubCategoryPostLoader = state;
    notifyListeners();
  }

  void reinitalize() {
    showActiveButton = false;
    currentPostIndex = 0;
  }

  void disposeValues() {
    jankaricardList = [];
    jankariSubcategoryList = [];
    jankariSubcategoryPostList = [];
    jankariSubCategoryLoader = false;
    jankariSubCategoryPostLoader = false;
    selectedCategory = "";
    selectedSubCategory = "";
    showSubCategoryModal = false;
    currentPostIndex = 0;
    showActiveButton = true;
    _loading = false;
  }

  void setCategory(String id) {
    selectedCategory = id;
    showSubCategoryModal = true;
    notifyListeners();
  }

  void setSelectedSubCategory(String id) {
    selectedSubCategory = id;
    currentPostIndex = 0;
    showSubCategoryModal = true;
    notifyListeners();
  }

  void getJankariCategory(BuildContext context) async {
    setloading(true);
    try {
      final data = await _jankariRepository.getJankariCategory();
      jankaricardList = mapJankariCategories(data['categories']);
      setloading(false);
      notifyListeners();
    } catch (error) {
      setloading(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
    }
  }

  List<JankariCategoryModal> mapJankariCategories(dynamic categories) {
    return List<JankariCategoryModal>.from(categories.map((category) {
      return JankariCategoryModal.fromJson(category);
    }));
  }

  void getJankariSubCategory(BuildContext context, String id) async {
    setJankariSubCategoryLoader(true);
    try {
      final data =
          await _jankariRepository.getJankariSubCategory(selectedCategory);
      jankariSubcategoryList = mapJankariSubCategory(data['subCategories']);
      setJankariSubCategoryLoader(false);
      notifyListeners();
    } catch (error) {
      setJankariSubCategoryLoader(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
    }
  }

  List<JankariSubCategoryModel> mapJankariSubCategory(dynamic categories) {
    return List<JankariSubCategoryModel>.from(categories.map((category) {
      return JankariSubCategoryModel.fromJson(category);
    }));
  }

  void getJankariSubCategoryPost(BuildContext context) async {
    setJankariSubCategoryLoaderPost(true);
    try {
      final data = await _jankariRepository
          .getJankariSubCategoryPost(selectedSubCategory);
      jankariSubcategoryPostList = mapJankariSubCategoryPost(data['posts']);
      if (jankariSubcategoryPostList.length > 1) {
        changeActiveButtonState(true);
      }
      setJankariSubCategoryLoaderPost(false);
      notifyListeners();
    } catch (error) {
      setJankariSubCategoryLoaderPost(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
    }
  }

  List<JankariSubCategoryPostModel> mapJankariSubCategoryPost(
      dynamic categories) {
    return List<JankariSubCategoryPostModel>.from(categories.map((category) {
      return JankariSubCategoryPostModel.fromJson(category);
    }));
  }

  dynamic shareFiles(String imagePath) async {
    final uri = Uri.parse(imagePath);
    final res = await http.get(uri);
    final bytes = res.bodyBytes;
    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.jpg';
    File(path).writeAsBytesSync(bytes);
    final xfile = XFile(path);
    return xfile;
  }
}
