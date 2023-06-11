import 'package:agriChikitsa/repository/jankari.repo/jankari_repository.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import '../../../model/jankari_card_modal.dart';
import '../../../model/jankari_subcategory_model.dart';

class JankariViewModel with ChangeNotifier {
  final _jankariRepository = JankariRepository();
  List<JankariCategoryModal> jankaricardList = [];
  List<JankariSubCategoryModel> jankariSubcategoryList = [];
  var _loading = true;
  var jankariSubCategoryLoader = false;
  var selectedCategory = "";
  var showSubCategoryModal = false;
  bool get loading {
    return _loading;
  }

  setloading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setJankariSubCategoryLoader(bool state) {
    jankariSubCategoryLoader = state;
    notifyListeners();
  }

  void disposeValues() {
    _loading = false;
  }

  void setCategory(String id) {
    selectedCategory = id;
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
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
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
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  List<JankariSubCategoryModel> mapJankariSubCategory(dynamic categories) {
    return List<JankariSubCategoryModel>.from(categories.map((category) {
      return JankariSubCategoryModel.fromJson(category);
    }));
  }
}
