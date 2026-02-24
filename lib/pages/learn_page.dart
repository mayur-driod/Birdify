import 'package:flutter/material.dart';

// ── Static educational data ───────────────────────────────────────────────────

class _Article {
  const _Article({required this.title, required this.body});
  final String title;
  final String body;
}

class _Category {
  const _Category({
    required this.label,
    required this.icon,
    required this.color,
    required this.articles,
  });
  final String label;
  final IconData icon;
  final Color color;
  final List<_Article> articles;
}

const _categories = <_Category>[
  _Category(
    label: 'Habitat',
    icon: Icons.forest_outlined,
    color: Color(0xFF2E7D32),
    articles: [
      _Article(
        title: 'Forests',
        body:
            'Forests are among the richest bird habitats on Earth, home to thousands of species. '
            'Tropical rainforests host the greatest diversity, with parrots, toucans, hornbills, and hummingbirds filling every layer from the forest floor to the canopy.\n\n'
            'Temperate forests are home to warblers, woodpeckers, owls, and thrushes. Each layer of the forest — the ground, understorey, mid-canopy, and upper canopy — is occupied by different species that have evolved to exploit specific niches.\n\n'
            'Deforestation remains the single greatest threat to forest birds. Even small patches of intact forest can serve as refuges and corridors for wildlife.',
      ),
      _Article(
        title: 'Wetlands',
        body:
            'Wetlands — marshes, swamps, lakes, rivers, and estuaries — support an extraordinary range of birds. '
            'Herons, egrets, storks, and kingfishers are master fishers adapted for shallow water hunting.\n\n'
            'Migratory waterfowl such as ducks, geese, and waders rely on wetlands as feeding and resting stopovers during long-distance journeys. '
            'The Ramsar Convention has designated over 2,000 wetlands worldwide as internationally important for bird conservation.\n\n'
            'Mangroves are a special coastal wetland habitat that shelter species like the mangrove kingfisher and various herons.',
      ),
      _Article(
        title: 'Urban Areas',
        body:
            'Cities are home to a surprising number of bird species. House sparrows, pigeons, mynahs, crows, and kites thrive in urban environments, '
            'exploiting food waste and nesting on buildings.\n\n'
            'Peregrine falcons have colonised city skyscrapers, where tall buildings mimic cliff faces and abundant pigeons provide prey. '
            'Urban parks and tree-lined streets act as green corridors connecting larger natural areas.\n\n'
            'Light pollution, glass buildings, and outdoor cats are key threats to urban birds. Simple measures like dimming lights and adding bird-safe glass decals can save millions of birds annually.',
      ),
    ],
  ),
  _Category(
    label: 'Diet',
    icon: Icons.restaurant_outlined,
    color: Color(0xFF8D4E0B),
    articles: [
      _Article(
        title: 'Insectivores',
        body:
            'Insectivorous birds such as swallows, swifts, warblers, and bee-eaters are vital for controlling insect populations. '
            'Swallows and swifts catch prey on the wing, making astonishing aerial manoeuvres to intercept flying insects.\n\n'
            'Woodpeckers use their long, barbed tongues to extract wood-boring beetle larvae from beneath tree bark. '
            'They can hammer a tree up to 20 times per second, supported by shock-absorbing skull bones.\n\n'
            'The global decline in insect populations directly threatens insectivorous birds, contributing to the collapse of many populations across the world.',
      ),
      _Article(
        title: 'Seed Eaters',
        body:
            'Granivorous birds — finches, sparrows, buntings, doves — are beautifully adapted to process hard seeds. '
            'Their strong, conical bills exert enormous crushing force relative to their size.\n\n'
            'Crossbills have evolved uniquely crossed mandibles that prise open conifer cones for the seeds inside. '
            'Different crossbill species are specialised for different cone sizes, showcasing the power of dietary specialisation.\n\n'
            'Seed-eating birds are important dispersers, dropping or caching seeds far from the parent plant, aiding forest regeneration.',
      ),
      _Article(
        title: 'Raptors',
        body:
            'Birds of prey — eagles, hawks, falcons, owls — sit at the top of food chains and play a critical role in ecosystem regulation. '
            'Their sharp talons and hooked beaks are precision instruments evolved for capturing and dismembering prey.\n\n'
            'Owls swallow prey whole and regurgitate indigestible fur and bone as compact "pellets". '
            'Dissecting owl pellets reveals the diet of these secretive nocturnal hunters.\n\n'
            'The peregrine falcon is the fastest animal on Earth, reaching diving speeds of over 380 km/h when stooping on prey.',
      ),
    ],
  ),
  _Category(
    label: 'Migration',
    icon: Icons.flight_outlined,
    color: Color(0xFF1565C0),
    articles: [
      _Article(
        title: 'Why Birds Migrate',
        body:
            'Migration is the seasonal movement of birds between breeding and wintering grounds, driven primarily by food availability and temperature. '
            'As insect populations crash and daylight shortens in autumn, many birds fly to warmer regions where food is abundant.\n\n'
            'The decision to migrate is triggered by changing day-length (photoperiod), which stimulates hormonal changes in the bird\'s body. '
            'This internal clock is so precise that captive birds still show migratory restlessness at the correct time of year.\n\n'
            'Not all populations of a species migrate equally — some individuals winter closer to home, a strategy called "partial migration".',
      ),
      _Article(
        title: 'Navigation',
        body:
            'Birds use a remarkable combination of navigational tools. They can read the position of the sun and stars, '
            'sense Earth\'s magnetic field using magnetite crystals in their beaks, and recognise coastal landmarks and river systems.\n\n'
            'Young birds of many species migrate alone for the first time using an innate compass, guided by a genetic programme that specifies direction and distance. '
            'They refine this skill through experience over multiple seasons.\n\n'
            'Bar-tailed godwits hold the record for non-stop flight — up to 13,000 km from Alaska to New Zealand without landing, fuelled by massive pre-migratory fat reserves.',
      ),
      _Article(
        title: 'India as a Flyway',
        body:
            'India lies along the Central Asian Flyway, one of the world\'s busiest bird migration routes. '
            'Millions of ducks, geese, waders, and raptors pass through each winter, coming from breeding grounds in Siberia, Central Asia, and Tibet.\n\n'
            'Key wintering sites include Chilika Lake in Odisha, the Keoladeo National Park in Rajasthan, and the Rann of Kutch. '
            'The Amur falcon, which breeds in northeast Asia and winters in south Africa, stages a spectacular stopover in Nagaland.\n\n'
            'Climate change is altering the timing and geography of bird migration, with many species now arriving earlier in spring than they did 50 years ago.',
      ),
    ],
  ),
  _Category(
    label: 'Behaviour',
    icon: Icons.music_note_outlined,
    color: Color(0xFF6A1B9A),
    articles: [
      _Article(
        title: 'Bird Song',
        body:
            'Birdsong is one of nature\'s most complex communication systems. Birds sing primarily to defend territories and attract mates. '
            'Songbirds (oscines) learn their songs from their parents, producing dialects that vary between populations.\n\n'
            'The superb lyrebird of Australia can mimic chainsaws, camera shutters, and other bird species with extraordinary fidelity. '
            'Some species have repertoires of hundreds of distinct song types.\n\n'
            'Birds hear ultrasonic details in each other\'s songs that are inaudible to humans. Modern spectrogram analysis reveals patterns invisible to the ear.',
      ),
      _Article(
        title: 'Flocking',
        body:
            'Many bird species flock for safety — thousands of eyes spot predators far more efficiently than one. '
            'The shimmering, undulating murmurations of starlings contain millions of birds moving in fluid synchrony, each individual responding to its immediate neighbours.\n\n'
            'Foraging flocks are often "mixed species" — for example, drongos, babblers, and minivets moving through forests together. '
            'The drongo acts as a sentinel, alerting others to danger and occasionally stealing prey for itself.\n\n'
            'V-formation flight in geese reduces drag for trailing birds, saving up to 25 % of their energy during long migrations.',
      ),
    ],
  ),
  _Category(
    label: 'Nesting',
    icon: Icons.home_outlined,
    color: Color(0xFFE65100),
    articles: [
      _Article(
        title: 'Nest Types',
        body:
            'Bird nests range from the simplest scrapes in the ground to elaborate woven structures. '
            'Weaver birds construct intricate pendant nests from grass stems, knotted in dozens of loops — perhaps the most complex structures built by any animal.\n\n'
            'The edible-nest swiftlet uses pure saliva to construct its nest — the basis of the famous "bird\'s nest soup" delicacy in Asian cuisine. '
            'Malleefowl build enormous mound nests where decomposing vegetation generates heat to incubate eggs.\n\n'
            'Cavity nesters such as owls, kingfishers, and bee-eaters excavate burrows or use hollow trees, making them highly sensitive to the loss of old-growth timber.',
      ),
      _Article(
        title: 'Parental Care',
        body:
            'Parental care varies enormously across birds. Emperor penguins fast for 65 days in Antarctic blizzards, balancing a single egg on their feet. '
            'Megapode birds lay eggs and abandon them, relying entirely on geothermal or solar heat for incubation.\n\n'
            'In some species, helpers — usually older siblings — assist the parents in feeding the chicks, a strategy called cooperative breeding. '
            'This is common in bee-eaters, kookaburras, and scrub-jays.\n\n'
            'Brood parasites like cuckoos lay their eggs in other birds\' nests, leaving all parental duties to the unwitting host. '
            'The cuckoo chick hatches early, ejects the host\'s eggs, and then mimics the sound of a full brood to stimulate maximum feeding.',
      ),
    ],
  ),
  _Category(
    label: 'Conservation',
    icon: Icons.eco_outlined,
    color: Color(0xFFC62828),
    articles: [
      _Article(
        title: 'Threats to Birds',
        body:
            'An estimated 1 in 8 bird species is threatened with extinction. The four biggest threats are habitat loss, invasive species, '
            'hunting and trapping, and climate change.\n\n'
            'Domestic and feral cats kill an estimated 2.4 billion birds each year in North America alone. '
            'Glass collisions kill hundreds of millions more. Both threats are largely preventable through simple behavioural and design changes.\n\n'
            'The passenger pigeon — once the world\'s most numerous bird with flocks of billions — was hunted to extinction by 1914, '
            'standing as a stark warning of how quickly abundance can become absence.',
      ),
      _Article(
        title: 'Conservation Success',
        body:
            'Bird conservation has notable success stories. The California condor was down to just 27 birds in 1987; today over 500 exist, '
            'thanks to a captive breeding and reintroduction programme.\n\n'
            'In India, vulture populations that collapsed 99 % in the 1990s due to the livestock drug diclofenac are slowly recovering '
            'following a government ban and captive breeding programmes.\n\n'
            'Citizen science projects like the Christmas Bird Count and eBird have transformed our understanding of bird population trends, '
            'putting millions of birdwatchers to work as a global monitoring network.',
      ),
    ],
  ),
];

// ── Learn Page ────────────────────────────────────────────────────────────────

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 24,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.auto_stories_outlined, color: cs.primary, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'Bird Basics',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: -0.3,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    cs.primary.withValues(alpha: 0.12),
                    cs.primary.withValues(alpha: 0.04),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: cs.primary.withValues(alpha: 0.18),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.flutter_dash, size: 40, color: cs.primary),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explore the Bird World',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: cs.onSurface,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap a topic below to start learning.',
                          style: TextStyle(
                            fontSize: 13,
                            color: cs.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'TOPICS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: cs.onSurface.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.25,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, i) {
                final cat = _categories[i];
                return _CategoryCard(
                  category: cat,
                  cs: cs,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => _CategoryDetailPage(category: cat),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Category Card ─────────────────────────────────────────────────────────────

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.cs,
    required this.onTap,
  });

  final _Category category;
  final ColorScheme cs;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = category.color;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: color.withValues(alpha: 0.08),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(category.icon, color: color, size: 22),
              ),
              const Spacer(),
              Text(
                category.label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${category.articles.length} article${category.articles.length != 1 ? "s" : ""}',
                style: TextStyle(
                  fontSize: 12,
                  color: cs.onSurface.withValues(alpha: 0.4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Category Detail Page ──────────────────────────────────────────────────────

class _CategoryDetailPage extends StatelessWidget {
  const _CategoryDetailPage({required this.category});
  final _Category category;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = category.color;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: cs.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          category.label,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: -0.3,
            color: cs.onSurface,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          // Category header bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(category.icon, color: color, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Learn about ${category.label.toLowerCase()}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...category.articles.expand(
            (article) => [
              _ArticleCard(article: article, color: color, cs: cs),
              const SizedBox(height: 14),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({
    required this.article,
    required this.color,
    required this.cs,
  });

  final _Article article;
  final Color color;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                article.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            article.body,
            style: TextStyle(
              fontSize: 14.5,
              height: 1.7,
              color: cs.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
