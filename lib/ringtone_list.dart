import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';

class ringtoneList extends StatefulWidget {
  const ringtoneList({super.key});

  @override
  State<ringtoneList> createState() => _ringtoneListState();
}

class _ringtoneListState extends State<ringtoneList> {
  List ringtones = [];
  var player = FlutterSoundPlayer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ringtones'),),
      body: Center(
        child: Column(
          children: [
            if(ringtones.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: ringtones.length,
                  itemBuilder: (_, index){
                    final ringtone =  ringtones[index];
                    return Card(
                      child: ListTile(
                        onTap: () async{
                          try {
                            player = (await player.openAudioSession())!;
                            await player.startPlayer(
                              fromURI: '/system/media/audio/ringtones/$ringtone.ogg',
                              codec: Codec.opusOGG,
                            );
                          } catch (e) {
                            print('Error starting player: $e');
                          }
                        },
                        title: Text(ringtone),
                      ),
                    );
                  },
                ),
              ),
            ElevatedButton(onPressed: ()async{
              const channel = MethodChannel('ringtone_channel');
              ringtones = await channel.invokeMethod('getRingtones');
              setState(() {});
            }, 
                child: const Text('Get Ringtones')),
          ],
        ),
      ),
    );
  }
}
