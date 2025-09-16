class AudioMessage {
  final String title;
  final String audioImage;
  final String audioUrl;
  final String audioDescription;
  final String speaker;

  AudioMessage({
    required this.title,
    required this.audioImage,
    required this.audioUrl,
    required this.audioDescription,
    required this.speaker
  });

  static List<AudioMessage> audioMessage = [
    AudioMessage(
      title: 'Two Levels of encountering the Word',
      audioImage: 'assets/images/audioImage.png',
      audioUrl: 'assets/audios/Two Levels Of Encoutering The Word.mp3',
      audioDescription: 'audioDescription',
      speaker: 'Gbile Akanni'
    ),
    AudioMessage(
      title: 'Engaging your youthful years for kingdom exploits',
      audioImage: 'assets/images/audioImage.png',
      audioUrl: 'assets/audios/Engaging-Your-Youthful-Years-For-Kingdom-Exploits.mp3',
      audioDescription: 'audioDescription',
      speaker: 'Gbile Akanni'
    ),
  ];
}