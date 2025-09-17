import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/widget.dart';
import '../models/widget.dart';

class AudioMessages extends StatefulWidget {
  const AudioMessages({super.key});

  @override
  State<AudioMessages> createState() => _AudioMessagesState();
}

class _AudioMessagesState extends State<AudioMessages> {
  late TextEditingController searchAudioController;
  @override
  void initState() {
    super.initState();
    searchAudioController = TextEditingController();
  }

  @override
  void dispose() {
    searchAudioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<AudioMessage> audio = AudioMessage.audioMessage;

    void navigateToAudioScreen(AudioMessage audio) {
      GoRouter.of(context).go(
          '${LivingSeedMediaRouter.mediaPath}/${LivingSeedMediaRouter.audioScreenPath}',
          extra: audio);
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 17.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Theme.of(context).disabledColor.withOpacity(0.15),
                ),
              ),
              child: TextField(
                controller: searchAudioController,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Search for messages...',
                  prefixIcon: const Icon(Iconsax.audio_square),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Theme.of(context).disabledColor.withOpacity(0.2),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: audio.length,
              itemBuilder: (context, index) {
                var audioSound = audio[index];
                return InkWell(
                  onTap: () => navigateToAudioScreen(audioSound),
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 7),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).disabledColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.asset(
                              audioSound.audioImage,
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(audioSound.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold)),
                                Text(audioSound.speaker,
                                    maxLines: 2,
                                    style:
                                        Theme.of(context).textTheme.bodySmall)
                              ],
                            ),
                          )
                        ],
                      )),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
