import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PollSection extends StatefulWidget {
  // const PollSection({Key? key}) : super(key: key);

  @override
  State<PollSection> createState() => _PollSectionState();
}

class _PollSectionState extends State<PollSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('Vote'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    ]
    );
  }
}
