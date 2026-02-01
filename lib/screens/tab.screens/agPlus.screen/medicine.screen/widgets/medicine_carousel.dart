import 'dart:async';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/medicine.screen/medicine_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/pestAndDisease.screen/widgets/pest_carousel.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:agriChikitsa/l10n/app_localizations.dart';

class WeedCarouselWithFeedback extends StatefulWidget {
  final List<dynamic> chemicals;
  final MedicineViewModel medicineViewModel;
  const WeedCarouselWithFeedback(
      {super.key, required this.chemicals, required this.medicineViewModel});

  @override
  State<WeedCarouselWithFeedback> createState() => _WeedCarouselWithFeedbackState();
}

class _WeedCarouselWithFeedbackState extends State<WeedCarouselWithFeedback> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  Timer? _autoScrollTimer;
  Map<String, Timer?> _debounceTimers = {};

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_currentPage < widget.chemicals.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.ease,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.ease,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  void _handleLike(dynamic chemical) {
    setState(() {
      if (chemical["isLiked"]) {
        chemical["isLiked"] = false;
        if (chemical["likes"].isNotEmpty) {
          chemical["likes"].removeLast();
        }
      } else {
        chemical["isLiked"] = true;
        chemical["likes"].add("");
        chemical["isDisliked"] = false;
      }
    });

    _debounceTimers[chemical["_id"]]?.cancel();
    _debounceTimers[chemical["_id"]] = Timer(const Duration(milliseconds: 600), () {
      widget.medicineViewModel.toggleMedicineLike(context, chemical["_id"]);
    });
  }

  void _handleDislike(dynamic chemical) {
    setState(() {
      if (chemical["isDisliked"]) {
        chemical["isDisliked"] = false;
      } else {
        chemical["isDisliked"] = true;
        if (chemical["likes"].isNotEmpty) {
          chemical["likes"].removeLast();
        }
        chemical["isLiked"] = false;
      }
    });
    _debounceTimers[chemical["_id"]]?.cancel();
    _debounceTimers[chemical["_id"]] = Timer(const Duration(milliseconds: 600), () {
      widget.medicineViewModel.toggleMedicineDislike(context, chemical["_id"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return SizedBox(
      height: dimension["height"]! * 0.45,
      width: dimension['width']!,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.chemicals.length,
        itemBuilder: (context, index) {
          final chemical = widget.chemicals[index];
          final title = AppLocalization.of(context).locale.toString() == "en"
              ? chemical["brandNameEn"]
              : chemical["brandNameHi"];
          final subTitle = AppLocalization.of(context).locale.toString() == "en"
              ? chemical["companyNameEn"]
              : chemical["companyNameHi"];

          return AnimatedContainer(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: InkWell(
                    onTap: () =>
                        Utils.model(context, FullScreenImageViewer(imageUrl: chemical["image"])),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: (dimension["height"]! * 0.30 - 8),
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: chemical["image"],
                          fit: BoxFit.contain,
                          progressIndicatorBuilder: (context, url, downloadProgress) => Skeleton(
                            height: 100,
                            width: double.infinity,
                            radius: 0,
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 2,
                            style: const TextStyle(
                              color: AppColor.darkBlackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            subTitle,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () => _handleLike(chemical),
                          icon: Icon(
                            Icons.thumb_up,
                            color: chemical["isLiked"] ? Colors.green : Colors.grey,
                          ),
                        ),
                        Text(
                          chemical["likes"].length.toString(),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          onPressed: () => _handleDislike(chemical),
                          icon: Icon(
                            Icons.thumb_down,
                            color: chemical["isDisliked"] ? Colors.red : Colors.grey,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
