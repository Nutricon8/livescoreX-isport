import 'package:flutter/material.dart';
import 'package:live_score_ke/utils/colors.dart';
import 'package:live_score_ke/widgets/custom_filled_button.dart';

class OnboardingFour extends StatelessWidget {
  const OnboardingFour({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: null),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('2 of 2', style: TextStyle(color: null)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/main");
                },
                child: Text(
                  'Skip',
                  style: TextStyle(color: null, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Text(
                'Select your favourite tournaments and teams',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: null,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  TournamentLogo(
                    tournamentName: 'Premier League',
                    imageAsset: 'assets/premier_league.png',
                    onTap: () {},
                  ),
                  TournamentLogo(
                    tournamentName: 'Championship',
                    imageAsset: 'assets/liverpool.png',
                    onTap: () {},
                  ),
                  TournamentLogo(
                    tournamentName: 'Serie A',
                    imageAsset: 'assets/serie_a.png',
                    onTap: () {},
                  ),
                  TournamentLogo(
                    tournamentName: 'Bundesliga',
                    imageAsset: 'assets/liverpool.png',
                    onTap: () {},
                  ),
                  TournamentLogo(
                    tournamentName: 'Laliga',
                    imageAsset: 'assets/liverpool.png',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Divider(color: null),
            Expanded(
              child: ListView(
                children: const [
                  _TeamTile(
                    name: 'Arsenal',
                    subscribers: '14,812',
                    image: 'assets/liverpool.png',
                  ),
                  _TeamTile(
                    name: 'Aston Villa',
                    subscribers: '9,502',
                    image: 'assets/aston_villa.png',
                  ),
                  _TeamTile(
                    name: 'Bournemouth',
                    subscribers: '2,189',
                    image: 'assets/liverpool.png',
                  ),
                  _TeamTile(
                    name: 'Everton',
                    subscribers: '5,067',
                    image: 'assets/aston_villa.png',
                  ),
                  _TeamTile(
                    name: 'Southampton',
                    subscribers: '3,987',
                    image: 'assets/liverpool.png',
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: CustomFilledButton(
                text: 'Next',
                onPressed: () {
                  Navigator.pushNamed(context, "/main");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TournamentLogo extends StatefulWidget {
  final String tournamentName;
  final String imageAsset;
  final bool selected;
  final bool tapped;
  final VoidCallback onTap;

  const TournamentLogo({
    required this.tournamentName,
    required this.imageAsset,
    this.selected = false,
    this.tapped = false,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _TournamentLogoState createState() => _TournamentLogoState();
}

class _TournamentLogoState extends State<TournamentLogo> {
  late bool isSelected;
  late bool isTapped;

  @override
  void initState() {
    super.initState();
    isSelected = widget.selected;
    isTapped = widget.tapped;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTapped = !isTapped;
        });
      },
      child: SizedBox(
        width: isTapped ? 110 : 100, // Set a fixed width
        height: isTapped ? 110 : 100, // Set a fixed height
        child: Card(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color:
                          Theme.of(
                            context,
                          ).cardColor, // Example of using theme color
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                    child: Image.asset(widget.imageAsset, fit: BoxFit.fill),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.tournamentName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: IconButton(
                  icon: Icon(
                    Icons.star,
                    color: isSelected ? yellowColor : Colors.grey,
                  ),
                  iconSize: 18,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() {
                      isTapped = true;
                      isSelected = !isSelected;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamTile extends StatelessWidget {
  final String name;
  final String subscribers;
  final String image;

  const _TeamTile({
    //super.key,
    required this.name,
    required this.subscribers,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(image, width: 40, height: 40),
      title: Text(name, style: const TextStyle(fontSize: 16)),
      subtitle: Text(
        '$subscribers subscribers',
        style: const TextStyle(fontSize: 14),
      ),
      trailing: IconButton(icon: Icon(Icons.star_border), onPressed: () {}),
    );
  }
}
