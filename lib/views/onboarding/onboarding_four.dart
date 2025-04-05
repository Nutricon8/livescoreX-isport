import 'package:flutter/material.dart';
import 'package:livescore_x/utils/api_service.dart';
import 'package:livescore_x/utils/colors.dart';
import 'package:livescore_x/utils/favorite_teams.dart';
import 'package:livescore_x/utils/models/league.dart';
import 'package:livescore_x/utils/models/team.dart';
import 'package:livescore_x/widgets/custom_filled_button.dart';
import 'package:livescore_x/widgets/custom_image.dart';

class OnboardingFour extends StatefulWidget {
  const OnboardingFour({super.key});

  @override
  OnboardingFourState createState() => OnboardingFourState();
}

class OnboardingFourState extends State<OnboardingFour> {
  final PageController _pageController = PageController(viewportFraction: 0.4);
  double _currentPage = 0;

  late Future<List<League>> _leaguesFuture;
  List<Team> _teams = [];
  bool isLoading = true;

  List<int> favoriteTeamIds = [];

  @override
  void initState() {
    super.initState();
    _leaguesFuture = ApiService().getLeagues(); // ✅ Fetch leagues
    fetchTeamsAndLeagues(); // ✅ Ensure teams are fetched

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });

    loadFavoriteTeams();
  }

  Future<void> fetchTeamsAndLeagues() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Team> fetchedTeams = await ApiService().getPremierLeagueTeams();
      setState(() {
        _teams = fetchedTeams;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadFavoriteTeams() async {
    List<Team> teams = await getTeams();
    setState(() {
      favoriteTeamIds = teams.map((team) => team.id).toList();
    });
  }

  Future<void> toggleFavorite(Team team) async {
    setState(() {
      if (favoriteTeamIds.contains(team.id)) {
        favoriteTeamIds.remove(team.id);
      } else {
        favoriteTeamIds.add(team.id);
      }
    });

    List<Team> teams =
        favoriteTeamIds
            .map((id) => _teams.firstWhere((t) => t.id == id))
            .toList();
    await saveTeams(teams);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '2 of 2',
          style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, "/main"),
            child: const Text(
              'Skip',
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Select your favourite tournaments and teams',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),

            FutureBuilder<List<League>>(
              future: _leaguesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No tournaments available"));
                }

                final tournaments = snapshot.data!;

                return Column(
                  children: [
                    SizedBox(
                      height: 140,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: tournaments.length,
                        itemBuilder: (context, index) {
                          double scale =
                              (_currentPage - index).abs() < 0.5 ? 1 : 0.8;
                          return Center(
                            child: Transform.scale(
                              scale: scale,
                              child: LeagueLogo(
                                tournamentName: tournaments[index].name,
                                imageAsset: tournaments[index].image,
                                onTap: () {},
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        tournaments.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage.round() == index ? 12 : 8,
                          height: 4,
                          decoration: BoxDecoration(
                            color:
                                _currentPage.round() == index
                                    ? Theme.of(context).colorScheme.onSurface
                                    : Theme.of(context).colorScheme.onSecondary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 8),

            Expanded(
              child:
                  isLoading
                      ? const Center(
                        child: CircularProgressIndicator(),
                      ) // ✅ Loading state
                      : _teams.isEmpty
                      ? const Center(
                        child: Text("No teams available"),
                      ) // ✅ Handle empty state
                      : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        itemCount: _teams.length,
                        itemBuilder: (context, index) {
                          Team team = _teams[index];
                          return TeamTile(
                            team: team,
                            isFavorite: favoriteTeamIds.contains(team.id),
                            onFavoriteToggle: toggleFavorite,
                          );
                        },
                      ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomFilledButton(
                text: 'Next',
                onPressed:
                    () => Navigator.pushReplacementNamed(context, "/main"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeagueLogo extends StatefulWidget {
  final String tournamentName;
  final String imageAsset;
  final bool selected;
  final VoidCallback onTap;

  const LeagueLogo({
    required this.tournamentName,
    required this.imageAsset,
    this.selected = false,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _LeagueLogoState createState() => _LeagueLogoState();
}

class _LeagueLogoState extends State<LeagueLogo> {
  late bool isSelected;
  @override
  void initState() {
    super.initState();
    isSelected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },

      child: Column(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Card(
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                color: isDarkMode ? white6Percent : Colors.white,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                      CustomImage(
                        imageString: widget.imageAsset,
                        width: double.infinity,
                        height: double.infinity,
                        isFilled: true,
                      ),

                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 16,
                          height: 16,
                          alignment: Alignment.center,
                          //padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(
                            Icons.star_rounded,
                            color: isSelected ? yellowColor : Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 90, // Same width as the image
            child: Text(
              widget.tournamentName,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class TeamTile extends StatelessWidget {
  final Team team;
  final bool isFavorite;
  final Function(Team) onFavoriteToggle;

  const TeamTile({
    super.key,
    required this.team,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Theme.of(context).dividerColor),
        ),
      ),
      child: ListTile(
        //visualDensity: VisualDensity(horizontal: 0, vertical: -2),
        horizontalTitleGap: 8,
        minLeadingWidth: 20,

        //contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        contentPadding: EdgeInsets.zero, // Removes internal padding
        visualDensity: VisualDensity(vertical: -4), // Reduces height

        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: CustomImage(imageString: team.image, width: 32, height: 32),
        ),
        title: Text(
          team.name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        trailing: IconButton(
          style: ButtonStyle(fixedSize: WidgetStateProperty.all(Size(24, 24))),
          padding: EdgeInsets.all(4.0), // Less padding to fit the 16px icon
          icon: Icon(
            Icons.star_rounded,
            color: isFavorite ? yellowColor : Colors.grey.withOpacity(0.2),
            size: 16,
          ),
          onPressed: () => onFavoriteToggle(team),
        ),
      ),
    );
  }
}
