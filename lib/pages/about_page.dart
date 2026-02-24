import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Data ──────────────────────────────────────────────────────────────────────

class _SkillGroup {
  const _SkillGroup({
    required this.label,
    required this.icon,
    required this.skills,
  });
  final String label;
  final IconData icon;
  final List<String> skills;
}

class _Project {
  const _Project({
    required this.name,
    required this.tagline,
    required this.description,
    required this.stack,
    required this.icon,
  });
  final String name;
  final String tagline;
  final String description;
  final List<String> stack;
  final IconData icon;
}

const _skillGroups = <_SkillGroup>[
  _SkillGroup(
    label: 'Frontend',
    icon: Icons.web_rounded,
    skills: ['React.js', 'Vite', 'Tailwind CSS', 'HTML5 & CSS3'],
  ),
  _SkillGroup(
    label: 'Mobile',
    icon: Icons.phone_android_rounded,
    skills: ['Flutter', 'Dart'],
  ),
  _SkillGroup(
    label: 'Backend',
    icon: Icons.dns_rounded,
    skills: ['Node.js', 'Express.js', 'REST API Design', 'JWT Auth'],
  ),
  _SkillGroup(
    label: 'AI & Integrations',
    icon: Icons.smart_toy_outlined,
    skills: ['Gemini API (Vision + Chat)', 'AI Prompt Engineering', 'Google Maps API', 'Cloudinary'],
  ),
  _SkillGroup(
    label: 'Databases',
    icon: Icons.storage_rounded,
    skills: ['MongoDB', 'Mongoose', 'MySQL'],
  ),
  _SkillGroup(
    label: 'Tools & DevOps',
    icon: Icons.build_outlined,
    skills: ['Git & GitHub', 'Redux / Redux Thunk', 'Postman', 'Axios', 'Firebase'],
  ),
  _SkillGroup(
    label: 'Creative',
    icon: Icons.camera_alt_outlined,
    skills: ['Photography', 'UI/UX Design', 'Content Creation', 'Branding'],
  ),
];

const _projects = <_Project>[
  _Project(
    name: 'Birdify',
    tagline: 'AI-powered bird identification & learning',
    description:
        'A Flutter app combining Gemini Vision for instant bird identification with a conversational AI ornithology expert, educational content, and personal observation logging.',
    stack: ['Flutter', 'Dart', 'Gemini API', 'BLoC'],
    icon: Icons.flutter_dash,
  ),
  _Project(
    name: 'TerraQuest',
    tagline: 'Eco-travel & nature discovery platform',
    description:
        'A full-stack MERN application for discovering and sharing eco-friendly travel destinations, featuring interactive maps, user itineraries, and community reviews.',
    stack: ['React', 'Node.js', 'MongoDB', 'Google Maps API'],
    icon: Icons.travel_explore_rounded,
  ),
  _Project(
    name: 'Byte-2-Bite',
    tagline: 'AI-assisted recipe & nutrition app',
    description:
        'A smart recipe discovery platform where users photograph ingredients and receive AI-generated meal suggestions, nutritional breakdowns, and step-by-step cooking guides.',
    stack: ['React', 'Express', 'MongoDB', 'AI Integration'],
    icon: Icons.restaurant_menu_rounded,
  ),
];

// platform, display handle, copy value, brand color
const _links = <(IconData, String, String, String, Color)>[
  (Icons.work_outline_rounded, 'LinkedIn', '@mayurksetty', 'linkedin.com/in/mayurksetty', Color(0xFF0A66C2)),
  (Icons.code_rounded, 'GitHub', '@mayur-driod', 'github.com/mayur-driod', Color(0xFF24292F)),
  (Icons.language_rounded, 'Portfolio', 'mayursetty.vercel.app', 'mayursetty.vercel.app', Color(0xFF4338CA)),
  (Icons.mail_outline_rounded, 'Email', 'settymayurk@gmail.com', 'settymayurk@gmail.com', Color(0xFFEA4335)),
];

// ── Page ──────────────────────────────────────────────────────────────────────

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsing hero + sticky title bar
          SliverAppBar(
            expandedHeight: 380,
            collapsedHeight: kToolbarHeight,
            pinned: true,
            backgroundColor: cs.surface,
            elevation: 0,
            scrolledUnderElevation: 1,
            shadowColor: cs.onSurface.withValues(alpha: 0.08),
            leading: Navigator.of(context).canPop()
                ? IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: cs.onSurface,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                : null,
            title: Text(
              'About the Creator',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 17,
                letterSpacing: -0.3,
                color: cs.onSurface,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: _ProfileHero(cs: cs, isDark: isDark),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 48),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Bio ────────────────────────────────────────────────────
                _SectionHeader(label: 'ABOUT', cs: cs),
                const SizedBox(height: 12),
                _Card(
                  cs: cs,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, I\'m Mayur — a Full-Stack Developer, AI Builder & Wildlife Photographer.',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'I build things at the intersection of technology, creativity, and meaningful impact. My core expertise covers the MERN stack, paired with a deep focus on AI — I love integrating intelligent systems into practical applications people actually use.',
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.72,
                          color: cs.onSurface.withValues(alpha: 0.58),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'As a founding team member of Masusu, I\'ve worked across technical development, system design, client comms, and product growth. I bring a creative edge through photography and UI-first design thinking.',
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.72,
                          color: cs.onSurface.withValues(alpha: 0.58),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _QuoteCard(
                  text: '"Building intelligent tech that connects people with nature."',
                  cs: cs,
                ),
                const SizedBox(height: 32),

                // ── Tech Stack ───────────────────────────────────────────
                _SectionHeader(label: 'TECH STACK', cs: cs),
                const SizedBox(height: 12),
                _Card(
                  cs: cs,
                  child: Column(
                    children: List.generate(_skillGroups.length, (i) {
                      final g = _skillGroups[i];
                      final isLast = i == _skillGroups.length - 1;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: cs.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Icon(g.icon, size: 14, color: cs.primary),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                g.label,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: cs.onSurface,
                                  letterSpacing: -0.1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 9),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: g.skills
                                .map(
                                  (s) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: cs.primary.withValues(alpha: 0.07),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: cs.primary.withValues(alpha: 0.18),
                                      ),
                                    ),
                                    child: Text(
                                      s,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: cs.onSurface.withValues(alpha: 0.72),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          if (!isLast) ...[
                            const SizedBox(height: 14),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: cs.onSurface.withValues(alpha: 0.06),
                            ),
                            const SizedBox(height: 14),
                          ],
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Projects ─────────────────────────────────────────────
                _SectionHeader(label: 'PROJECTS', cs: cs),
                const SizedBox(height: 12),
                ..._projects.asMap().entries.map((entry) {
                  final isLast = entry.key == _projects.length - 1;
                  return Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
                    child: _ProjectCard(project: entry.value, cs: cs),
                  );
                }),
                const SizedBox(height: 32),

                // ── Experience ───────────────────────────────────────────
                _SectionHeader(label: 'EXPERIENCE', cs: cs),
                const SizedBox(height: 12),
                _ExperienceCard(cs: cs),
                const SizedBox(height: 32),

                // ── Connect ──────────────────────────────────────────────
                _SectionHeader(label: 'CONNECT', cs: cs),
                const SizedBox(height: 12),
                _Card(
                  cs: cs,
                  child: Column(
                    children: List.generate(_links.length, (i) {
                      final l = _links[i];
                      final isLast = i == _links.length - 1;
                      return Column(
                        children: [
                          _LinkRow(
                            icon: l.$1,
                            platform: l.$2,
                            handle: l.$3,
                            copyValue: l.$4,
                            color: l.$5,
                            cs: cs,
                          ),
                          if (!isLast)
                            Divider(
                              height: 1,
                              thickness: 1,
                              indent: 52,
                              color: cs.onSurface.withValues(alpha: 0.06),
                            ),
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 7, color: cs.primary),
                        const SizedBox(width: 7),
                        Text(
                          'Open to full-time & freelance opportunities',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: cs.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Profile Hero ──────────────────────────────────────────────────────────────

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.cs, required this.isDark});
  final ColorScheme cs;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primary.withValues(alpha: isDark ? 0.2 : 0.13),
            cs.surface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.88],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: kToolbarHeight + 6),
            // Avatar with glowing ring
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: cs.primary.withValues(alpha: 0.45),
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: cs.primary.withValues(alpha: 0.22),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/MayurKSettyProfilePic.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: cs.primary.withValues(alpha: 0.15),
                    child: Center(
                      child: Text(
                        'MS',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: cs.primary,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 13),
            Text(
              'Mayur K Setty',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Full-Stack Developer · AI Builder · Wildlife Photographer',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: cs.onSurface.withValues(alpha: 0.42),
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StatItem(value: '3+', label: 'Projects', cs: cs),
                _StatDivider(cs: cs),
                _StatItem(value: 'MERN', label: 'Stack', cs: cs),
                _StatDivider(cs: cs),
                _StatItem(value: 'AI', label: 'Integrations', cs: cs),
              ],
            ),
            const SizedBox(height: 13),
            // Badges
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: [
                  _Badge(icon: Icons.flutter_dash, label: 'Creator of Birdify', cs: cs),
                  _Badge(icon: Icons.business_center_outlined, label: 'Masusu — Marketing & Growth', cs: cs),
                  _Badge(icon: Icons.location_on_outlined, label: 'India', cs: cs),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label, required this.cs});
  final String value;
  final String label;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: cs.primary,
            letterSpacing: -0.2,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            color: cs.onSurface.withValues(alpha: 0.42),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: 1,
      height: 26,
      color: cs.onSurface.withValues(alpha: 0.1),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label, required this.cs});
  final IconData icon;
  final String label;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.primary.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: cs.primary),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: cs.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Project Card ──────────────────────────────────────────────────────────────

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project, required this.cs});
  final _Project project;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.08)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Green accent left edge
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(project.icon, color: cs.primary, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                project.name,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: cs.onSurface,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              Text(
                                project.tagline,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: cs.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Text(
                      project.description,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.65,
                        color: cs.onSurface.withValues(alpha: 0.56),
                      ),
                    ),
                    const SizedBox(height: 9),
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: project.stack
                          .map(
                            (s) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: cs.primary.withValues(alpha: 0.07),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: cs.primary.withValues(alpha: 0.18),
                                ),
                              ),
                              child: Text(
                                s,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: cs.primary,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Experience Card ───────────────────────────────────────────────────────────

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return _Card(
      cs: cs,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.business_center_outlined, color: cs.primary, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Masusu',
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w800,
                              color: cs.onSurface,
                              letterSpacing: -0.2,
                            ),
                          ),
                          Text(
                            'Founding Member',
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: cs.primary.withValues(alpha: 0.18)),
                      ),
                      child: Text(
                        'Startup',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: cs.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                Text(
                  'Worked across multiple roles — technical development, system architecture, client communication, content strategy, and product growth. Led end-to-end feature delivery in a fast-moving early-stage environment.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.68,
                    color: cs.onSurface.withValues(alpha: 0.56),
                  ),
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: ['System Design', 'Client Comms', 'Product Growth', 'Full-Stack Dev']
                      .map(
                        (s) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.07),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: cs.primary.withValues(alpha: 0.18)),
                          ),
                          child: Text(
                            s,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: cs.primary,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Link Row ──────────────────────────────────────────────────────────────────

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.platform,
    required this.handle,
    required this.copyValue,
    required this.color,
    required this.cs,
  });
  final IconData icon;
  final String platform;
  final String handle;
  final String copyValue;
  final Color color;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: copyValue));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Copied $platform link'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 11),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 17, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    platform,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  Text(
                    handle,
                    style: TextStyle(
                      fontSize: 12,
                      color: cs.onSurface.withValues(alpha: 0.42),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.copy_rounded, size: 14, color: cs.onSurface.withValues(alpha: 0.2)),
          ],
        ),
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.cs});
  final String label;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 12,
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: cs.onSurface.withValues(alpha: 0.36),
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.cs, required this.child});
  final ColorScheme cs;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.08)),
      ),
      child: child,
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.text, required this.cs});
  final String text;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.format_quote_rounded,
            size: 18,
            color: cs.primary.withValues(alpha: 0.4),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.55,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                color: cs.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
