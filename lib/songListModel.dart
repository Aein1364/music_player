class SongListModel {
  late String imagePath;
  late String songPath;
  late String title;
  SongListModel(
      {required this.imagePath, required this.songPath, required this.title});
}

List<SongListModel> song = <SongListModel>[
  SongListModel(
      imagePath: 'assets/fire.jpg',
      songPath: 'assets/song.mp3',
      title: 'Set Fire to the Rain'),
  SongListModel(
      imagePath: 'assets/hello.jpg',
      songPath: 'assets/Hello.mp3',
      title: 'Hello'),
  SongListModel(
      imagePath: 'assets/rolling.jpg',
      songPath: 'assets/Rolling-in-the-Deep.mp3',
      title: 'Rolling in the Deep'),
  SongListModel(
      imagePath: 'assets/skyfall.jpg',
      songPath: 'assets/Skyfall.mp3',
      title: 'Skyfall'),
];
