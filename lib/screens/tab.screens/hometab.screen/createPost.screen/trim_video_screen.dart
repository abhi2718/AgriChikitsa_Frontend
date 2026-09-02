import 'dart:io';
import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_trimmer/video_trimmer.dart';

class TrimVideoScreen extends StatefulWidget {
  final File videoFile;

  const TrimVideoScreen({super.key, required this.videoFile});

  @override
  State<TrimVideoScreen> createState() => _TrimVideoScreenState();
}

class _TrimVideoScreenState extends State<TrimVideoScreen> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;
  bool _isPlaying = false;
  bool _isLoadingVideo = true;
  bool _progressVisibility = false;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.videoFile).then((_) {
      if (mounted) {
        setState(() {
          _isLoadingVideo = false;
        });
      }
    });
  }

  Future<void> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    await _trimmer.saveTrimmedVideo(
      startValue: _startValue,
      endValue: _endValue,
      onSave: (outputPath) {
        if (mounted) {
          setState(() {
            _progressVisibility = false;
          });
        }
        if (outputPath != null && outputPath.isNotEmpty) {
          Navigator.pop(context, XFile(outputPath));
        } else {
          Navigator.pop(context, null);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: false,
        title: BaseText(
          title: AppLocalization.of(context)
                      .getTranslatedValue("cropVideoTitle")
                      .toString() !=
                  "null"
              ? AppLocalization.of(context)
                  .getTranslatedValue("cropVideoTitle")
                  .toString()
              : "Crop Video (Max 1 min)",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          _progressVisibility
              ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AppColor.whiteColor,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: ElevatedButton(
                    onPressed: _isLoadingVideo ? null : _saveVideo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.extraDark,
                      foregroundColor: AppColor.whiteColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                    child: Text(
                      AppLocalization.of(context)
                                  .getTranslatedValue("cropAndSave")
                                  .toString() !=
                              "null"
                          ? AppLocalization.of(context)
                              .getTranslatedValue("cropAndSave")
                              .toString()
                          : "Crop & Continue",
                      style: GoogleFonts.inter(
                        color: AppColor.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Visibility(
                visible: _progressVisibility,
                child: Column(
                  children: [
                    const LinearProgressIndicator(
                      backgroundColor: Colors.red,
                      color: AppColor.extraDark,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalization.of(context)
                                  .getTranslatedValue("trimmingProgress")
                                  .toString() !=
                              "null"
                          ? AppLocalization.of(context)
                              .getTranslatedValue("trimmingProgress")
                              .toString()
                          : "Processing video...",
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              Expanded(
                child: VideoViewer(trimmer: _trimmer),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: TrimViewer(
                  trimmer: _trimmer,
                  viewerHeight: 50.0,
                  viewerWidth: screenWidth - 32,
                  maxVideoLength: const Duration(seconds: 60),
                  durationStyle: DurationStyle.FORMAT_MM_SS,
                  durationTextStyle: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  editorProperties: TrimEditorProperties(
                    borderPaintColor: AppColor.darkColor,
                    borderWidth: 3,
                    borderRadius: 5,
                    circlePaintColor: AppColor.extraDark,
                  ),
                  areaProperties: TrimAreaProperties.edgeBlur(
                    thumbnailQuality: 50,
                  ),
                  onChangeStart: (value) => _startValue = value,
                  onChangeEnd: (value) => _endValue = value,
                  onChangePlaybackState: (value) =>
                      setState(() => _isPlaying = value),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: IconButton(
                    onPressed: () async {
                      bool playbackState = await _trimmer.videoPlaybackControl(
                        startValue: _startValue,
                        endValue: _endValue,
                      );
                      setState(() {
                        _isPlaying = playbackState;
                      });
                    },
                    icon: Icon(
                      _isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      size: 56.0,
                      color: AppColor.whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_isLoadingVideo)
            Container(
              color: Colors.black,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Loading video...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

