import 'dart:async';
import 'dart:io';

// import 'package:audioplayers/audioplayers.dart';
import 'package:coonch/common/widgets/like_share_row.dart';
import 'package:coonch/common/widgets/profile_data_row.dart';
import 'package:coonch/features/home/controllers/home_controller.dart';
import 'package:coonch/features/home/models/audio_model.dart';
import 'package:coonch/features/home/widgets/description_with_changeable_height_home.dart';
import 'package:coonch/utils/constants/image_strings.dart';
import 'package:coonch/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class AudioContentHome extends StatefulWidget {
  const AudioContentHome({
    super.key,
    required this.audioModel,
    required this.homeController,
  });

  final AudioModel audioModel;
  final HomeController homeController;

  @override
  State<AudioContentHome> createState() => _AudioContentHomeState();
}

class _AudioContentHomeState extends State<AudioContentHome> {
  late AudioPlayer _audioPlayer;
  late Duration _playPosition;
  late Duration _audioDuration;
  bool _isPlaying = false;
  String? path;
  late Directory appDirectory;

  @override
  void initState() {
    super.initState();
    _getDir();
    _audioPlayer = AudioPlayer();
    _playPosition = Duration.zero;
    _audioDuration = Duration.zero;

    _initAudio();
  }

  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
  }

  Future<void> _initAudio() async {
    print("_initAudio=======>${widget.audioModel.audioUrl}");
    AudioSource audioSource =
        AudioSource.uri(Uri.parse(widget.audioModel.audioUrl));

    await _audioPlayer.setAudioSource(audioSource);

    _audioPlayer.playerStateStream.listen((state) {
      if (context.mounted) {
        setState(() {
          _isPlaying = state.playing;
        });
      }
    });

    _audioPlayer.positionStream.listen((position) {
      if (context.mounted) {
        setState(() {
          _playPosition = position;
        });
      }
    });

    _audioPlayer.durationStream.listen((duration) {
      if (context.mounted) {
        setState(() {
        _audioDuration = duration ?? Duration.zero;
      });
      }
    });
  }

  @override
  void dispose() {
    if (context.mounted) {
      _audioPlayer.dispose();
    }
    super.dispose();
  }

  void _togglePlayback() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Profile Data Row
        ProfileDataRow(
          profileUrl: MImages.imgMyStatusProfile2,
          username: widget.audioModel.userName,
          userCategory: widget.audioModel.userCategory,
        ),

        /// Audio
        // Container(
        //   height: 50,
        //   width: MediaQuery.of(context).size.width,
        //   child: PolygonWaveform(
        //     maxDuration: _audioDuration,
        //     elapsedDuration: _playPosition,
        //     samples: [],
        //     activeColor: Colors.blue,
        //     // Customize waveform color if needed
        //     // progressColor: Colors.red, // Customize progress color if needed
        //     // handleColor: Colors.black, // Customize handle color if needed
        //     // onChanged: (Duration position) {
        //     //   setState(() {
        //     //     _playPosition = position;
        //     //   });
        //     //   _audioPlayer.seek(position);
        //     // },
        //     height: 50,
        //     width: double.infinity,
        //   ),
        //
        // ),
        // For a regular waveform
        PolygonWaveform(
          samples: [],
          height: 50,
          width: 50,
        ),
        Container(
          height: 50,
          child: Row(
            children: [
              /// Button
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () {
                    _isPlaying ? _audioPlayer.pause() : _audioPlayer.play();
                  },
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                ),
              ),

              /// Slider
              Expanded(
                flex: 9,
                child: Slider(
                  min: 0,
                  max: _audioDuration.inSeconds.toDouble(),
                  value: _playPosition.inSeconds.toDouble(),
                  onChanged: (value) {
                    final position = Duration(seconds: value.toInt());
                    _audioPlayer.seek(position);
                  },
                ),
              )
            ],
          ),
        ),

        const SizedBox(height: MSizes.sm),

        /// Description
        DescriptionWithChangeableHeightHome(
          model: widget.audioModel,
          homeController: widget.homeController,
        ),

        const SizedBox(height: MSizes.sm),

        /// Like, Share & etc.
        LikeShareRow(
          commentNo: widget.audioModel.commentNo,
          likeNo: widget.audioModel.likesNo,
        ),
      ],
    );
  }
}
