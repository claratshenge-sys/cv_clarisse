import 'package:flutter/material.dart';

void main() => runApp(const CvApp());

const navy = Color(0xFF183B63);
const pink = Color(0xFFE9A7C2);
const palePink = Color(0xFFFFF0F6);

class CvApp extends StatelessWidget {
  const CvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CV - Clarisse Lodi',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: navy),
        scaffoldBackgroundColor: const Color(0xFFF8F9FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const LoginPage(),
    );
  }
}

// PAGE DE CONNEXION

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  bool hidePassword = true;
  String? error;

  void login() {
    if (idController.text.trim().toLowerCase() == 'clarisse' &&
        passwordController.text == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    } else {
      setState(() {
        error = 'Identifiant ou mot de passe incorrect.';
      });
    }
  }

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [navy, Color(0xFF345D87), pink],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 52,
                      backgroundImage: AssetImage('assets/images/clarisse.jpg'),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Bienvenue',
                      style: TextStyle(
                        color: navy,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('Connectez-vous pour découvrir mon CV'),
                    const SizedBox(height: 24),
                    TextField(
                      controller: idController,
                      decoration: const InputDecoration(
                        labelText: 'Identifiant',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: passwordController,
                      obscureText: hidePassword,
                      onSubmitted: (_) => login(),
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          icon: Icon(
                            hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),
                    if (error != null) ...[
                      const SizedBox(height: 10),
                      Text(error!, style: const TextStyle(color: Colors.red)),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: navy),
                        onPressed: login,
                        child: const Text('Se connecter'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Démo : identifiant clarisse • mot de passe 2007',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// PAGE PRINCIPALE

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selected = 0;

  final pages = const [HomePage(), FamilyPage(), ContactPage()];

  final titles = const ['Mon CV', 'Ma famille', 'Me contacter'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titles[selected])),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: navy),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundImage: AssetImage('assets/images/clarisse.jpg'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Clarisse Lodi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Développeuse d’applications',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            _drawerItem(Icons.home, 'Accueil', 0),
            _drawerItem(Icons.family_restroom, 'Famille', 1),
            _drawerItem(Icons.contact_mail, 'Contact', 2),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: pages[selected],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (i) {
          setState(() {
            selected = i;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            label: 'Famille',
          ),
          NavigationDestination(
            icon: Icon(Icons.mail_outline),
            label: 'Contact',
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String label, int index) {
    return ListTile(
      leading: Icon(icon, color: navy),
      title: Text(label),
      selected: selected == index,
      onTap: () {
        setState(() {
          selected = index;
        });
        Navigator.pop(context);
      },
    );
  }
}

// PAGE CV

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Card(
          color: palePink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 66,
                  backgroundImage: AssetImage('assets/images/clarisse.jpg'),
                ),
                const SizedBox(height: 14),
                const Text(
                  'CLARISSE LODI',
                  style: TextStyle(
                    color: navy,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Programmeuse • Développeuse d’applications',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: navy),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Étudiante en Informatique de gestion — L3',
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'ISIG Goma',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        const CvSection(
          title: 'Formation',
          icon: Icons.school,
          children: [
            'ISIG Goma — Licence 3 en Informatique de gestion (en cours)',
          ],
        ),
        const CvSection(
          title: 'Expériences',
          icon: Icons.work_outline,
          children: [
            'Stages, projets et expériences professionnelles:entreprise, développement d’applications, maintenance de systèmes informatiques, etc.',
          ],
        ),
        const CvSection(
          title: 'Compétences techniques',
          icon: Icons.code,
          children: [
            'Programmation et développement d’applications.',
            'Conception et réalisation de bases de données.',
          ],
        ),
        const CvSection(
          title: 'Langues',
          icon: Icons.language,
          children: ['Français'],
        ),
        const CvSection(
          title: 'Expériences professionnelles',
          icon: Icons.work_outline,
          children: [
            'Stage académique : participation aux activités informatiques en entreprise.',
            'Travaux pratiques en HTML et CSS.',
            'Conception de pages web avec WordPress.',
            'Initiation au développement d’applications avec Flutter.',
          ],
        ),
      ],
    );
  }
}

// SECTIONS DU CV

class CvSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> children;

  const CvSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: navy),
                const SizedBox(width: 9),
                Text(
                  title,
                  style: const TextStyle(
                    color: navy,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...children.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•  '),
                    Expanded(child: Text(item)),
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

// PAGE FAMILLE

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    const family = [
      ('Joseph Lodi', 'Père', Icons.man),
      ('Louisette', 'Mère', Icons.woman),
      ('Cécile', 'Grande sœur', Icons.person),
      ('François', 'Petit frère', Icons.person),
      ('Joseph', 'Petit frère', Icons.person),
      ('Fidèle', 'Petit frère', Icons.person),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Les personnes qui me sont chères',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: navy,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...family.map(
          (person) => Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: palePink,
                child: Icon(person.$3, color: navy),
              ),
              title: Text(person.$1),
              subtitle: Text(person.$2),
              trailing: const Icon(Icons.favorite, color: pink),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'Les noms de votre famille sont affichés. Vous pourrez ajouter leurs photos plus tard.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

// PAGE CONTACT

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: const [
        Card(
          child: ListTile(
            leading: Icon(Icons.phone, color: navy),
            title: Text('Téléphone'),
            subtitle: Text('0825117627'),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.email, color: navy),
            title: Text('E-mail'),
            subtitle: Text('clarisselodi68@gmail.com'),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.location_on, color: navy),
            title: Text('Adresse'),
            subtitle: Text(
              'Adresse physique Goma, République Démocratique du Congo',
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.link, color: navy),
            title: Text('Réseaux sociaux'),
            subtitle: Text('LinkedIn / GitHub : claratshenge'),
          ),
        ),
      ],
    );
  }
}
