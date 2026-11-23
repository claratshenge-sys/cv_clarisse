# CV Clarisse Lodi — TP2 Flutter

Application Flutter de présentation du CV de Clarisse Lodi, étudiante en
Informatique de gestion à l’ISIG Goma. Le projet conserve les pages CV,
Famille et Contact, son thème rose et bleu, ainsi que les photos et informations
déjà présentes.

## Fonctionnalités

- Inscription et connexion auprès de l’API PHP : aucun compte fictif n’est
  accepté par l’application.
- Affichage des pages CV, Famille et Contact.
- Photos locales des proches déjà présentés dans le CV.
- Gestion depuis le serveur des membres de famille : liste, détails, ajout,
  modification et suppression.
- Sélection facultative d’une photo dans la galerie et envoi en
  `multipart/form-data`.
- Indicateurs de chargement, affichage des erreurs API et confirmation avant
  suppression.

Les photos locales du CV ne créent pas automatiquement des fiches dans MySQL.
Les fiches de la section « Membres enregistrés sur le serveur » sont chargées
depuis l’API.

## Technologies et organisation

- Flutter / Dart (contrainte Dart `^3.14.0` dans `pubspec.yaml`)
- PHP et API REST sans framework
- MySQL via XAMPP
- Packages Flutter : `http`, `http_parser`, `image_picker`,
  `device_info_plus` et `material_ui`
- Configuration de l’URL API : `lib/services/api_config.dart`
- Requêtes et réponses JSON : `lib/services/api_service.dart`
- Modèle familial : `lib/models/family_member.dart`
- Écrans : `lib/screens/`

## Prérequis

- Windows avec XAMPP (Apache, MySQL et PHP)
- Git, Flutter et Dart compatibles avec la contrainte du projet
- Microsoft Edge ou Chrome pour Flutter Web
- Android Studio et un émulateur Android, ou un téléphone Android, pour les
  essais mobiles

## Installation et démarrage du backend XAMPP

1. Installer XAMPP, puis ouvrir le **XAMPP Control Panel** et démarrer
   **Apache** et **MySQL**.
2. Installer le dépôt de l’API dans `C:\xampp\htdocs\api-test`. Si le dossier
   n’existe pas encore, depuis PowerShell :

   ```powershell
   git clone https://github.com/espoirbaraka/api-test.git C:\xampp\htdocs\api-test
   ```

   Si le dossier existe déjà, ne pas le cloner par-dessus.
3. Vérifier la présence de `C:\xampp\htdocs\api-test\public\index.php`,
   `api.sql` et `.env.example`.
4. Dans un navigateur, ouvrir `http://localhost/phpmyadmin/`. Créer la base
   `api`, choisir cette base, puis utiliser **Importer** pour importer
   `C:\xampp\htdocs\api-test\api.sql`. Le script fournit les tables
   `account`, `famille_membre` et `tbl_etudiant`. Importer le script une seule
   fois pour une installation neuve.
5. Dans `C:\xampp\htdocs\api-test`, créer `.env` à partir de `.env.example`
   uniquement s’il n’existe pas déjà, puis vérifier les paramètres :

   ```env
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=api
   DB_USERNAME=root
   DB_PASSWORD=
   ```

   Adaptez `DB_USERNAME` et `DB_PASSWORD` si MySQL est configuré avec d’autres
   identifiants. Le mot de passe vide correspond à la configuration XAMPP
   locale par défaut ; ne l’utilisez pas comme configuration de production.
6. Vérifier une route qui lit MySQL :

   ```powershell
   Invoke-RestMethod http://localhost/api-test/public/famille-membres
   ```

   Une réponse JSON avec `success: true` confirme que l’API et la base
   communiquent. Une liste vide signifie simplement qu’aucune fiche n’est
   enregistrée.

### URL de l’API et routes

URL de base en développement :

```text
http://localhost/api-test/public
```

Ouvrir cette URL seule, ou `.../public/`, peut répondre
`{"success":false,"message":"Route introuvable"}` : aucune route racine n’est
déclarée. Ce n’est pas le test de santé de l’API ; tester une route ci-dessous.
Le README de référence de l’API se trouve dans
`C:\xampp\htdocs\api-test\README.md`.

| Méthode | URL complète | Usage |
|---|---|---|
| POST | `http://localhost/api-test/public/accounts/register` | Inscription |
| POST | `http://localhost/api-test/public/accounts/login` | Connexion |
| GET | `http://localhost/api-test/public/famille-membres` | Liste familiale |
| GET | `http://localhost/api-test/public/famille-membres/{id}` | Détail par ID |
| POST | `http://localhost/api-test/public/famille-membres` | Créer une fiche |
| PUT | `http://localhost/api-test/public/famille-membres/{id}` | Modifier une fiche sans changer la photo |
| POST | `http://localhost/api-test/public/famille-membres/{id}` | Modifier une fiche avec une nouvelle photo |
| DELETE | `http://localhost/api-test/public/famille-membres/{id}` | Supprimer une fiche |

`{id}` doit être remplacé par l’identifiant numérique d’une fiche existante.
Les routes de compte reçoivent un JSON avec `email` et `password`. L’inscription
exige un e-mail valide et un mot de passe d’au moins 6 caractères ; l’e-mail
doit être unique.

Pour créer ou modifier une fiche, l’API exige tous les champs suivants :
`nom`, `postnom`, `prenom`, `lieu_naissance`, `date_naissance`
(format `AAAA-MM-JJ`, non future) et `parente`. Sans photo, envoyer un JSON avec
`Content-Type: application/json`. Avec photo, envoyer les champs et `image` en
`multipart/form-data`. Les formats indiqués par l’API sont JPG, PNG, GIF et
WebP, avec une limite de 2 Mo. Pour modifier la photo, utiliser POST sur
`/famille-membres/{id}` ; PHP ne lit pas les fichiers envoyés en PUT.

Les réponses sont JSON et contiennent `success`, `message` et, en cas de
succès, éventuellement `data`. Les principaux codes documentés sont 200/201
(succès), 401 (identifiants refusés), 404 (route ou fiche absente), 409
(e-mail déjà utilisé), 422 (champs invalides) et 500 (erreur serveur ou base).
L’application affiche les erreurs reçues au lieu d’ouvrir le CV après un échec
de connexion.

L’API actuelle ne demande pas de jeton d’authentification pour ses routes
familiales. L’authentification vérifie les comptes auprès de l’API, mais
n’ajoute pas de contrôle d’accès aux routes CRUD.

### CORS

Le backend local répond aux requêtes préflight OPTIONS et autorise actuellement
les méthodes nécessaires ainsi que l’en-tête `Content-Type`. Cette configuration
large convient au TP local ; elle doit être restreinte avant toute exposition
publique.

## Installation et exécution de Flutter

Depuis PowerShell, à la racine `C:\cv_clarisse` :

```powershell
flutter pub get
flutter analyze
flutter test
```

Démarrer l’application dans Microsoft Edge après avoir lancé Apache et MySQL :

```powershell
flutter run -d edge
```

Pour l’exécuter sur un émulateur Android :

```powershell
flutter devices
flutter run -d <device-id>
```

L’application sélectionne l’adresse API selon la plateforme :

| Plateforme | Adresse |
|---|---|
| Edge / Chrome (Flutter Web) et Windows desktop | `http://localhost/api-test/public` |
| Émulateur Android | `http://10.0.2.2/api-test/public` |
| Téléphone Android physique | `http://<IP_LOCALE_DU_PC>/api-test/public` |

Pour un téléphone physique, PC et téléphone doivent être sur le même réseau.
Repérer l’adresse IPv4 du PC avec `ipconfig`, puis la fournir au lancement :

```powershell
flutter run -d <device-id> --dart-define=API_LAN_HOST=<IP_DU_PC>
```

Par exemple, remplacer `<IP_DU_PC>` par l’adresse IPv4 actuelle du PC. Ne pas
inclure `http://` ni le chemin API dans `API_LAN_HOST`. L’adresse par défaut
dans le code est propre au réseau local actuel et peut changer. Le pare-feu
Windows doit autoriser Apache sur le réseau privé.

## Vérifications réalisées et limites connues

- `flutter test` : 9 tests passés ; `flutter analyze` : aucune erreur lors de la
  dernière vérification.
- Une session Edge a utilisé l’API et MySQL réels : inscription et connexion
  avec un compte de test temporaire, refus d’un mauvais mot de passe, lecture
  de la liste et du détail, création, modification et suppression d’une fiche.
  Les enregistrements temporaires ont ensuite été supprimés ; le compte
  préexistant a été conservé.
- Le parcours précédent a révélé puis corrigé un callback `setState` asynchrone
  sur la page de détail. Après correction, la modification depuis cette page a
  été vérifiée dans l’interface et dans MySQL.
- Les tests unitaires couvrent la sélection des URL pour Web, Windows,
  émulateur et téléphone, ainsi que la construction d’une requête multipart.
- **Non vérifié en réel dans cette session :** téléversement d’un fichier image
  vers l’API depuis Edge, essai sur émulateur/téléphone physique et compilation
  Android APK. Aucun appareil Android n’était connecté ; l’environnement
  Android doit disposer du NDK demandé par Gradle pour produire un APK.

## Captures d’écran

Les captures ne sont pas encore incluses dans le dépôt. Avant la remise, ajouter
des captures réelles de l’inscription, de la connexion, du CV, de Famille, du
formulaire et du détail d’un membre. Ne pas afficher un mot de passe réel ni
des données personnelles de test.

## Démonstration vidéo

Les quatre vidéos MP4 sont stockées avec Git LFS. Les liens ci-dessous pointent
directement vers les fichiers hébergés par GitHub. L’aperçu intégré de la page
du dépôt peut ne pas être disponible pour les fichiers LFS volumineux ; selon
le navigateur, le lien ouvre la vidéo ou la télécharge.

1. **Fichier `api.sql` et backend** — [Lire la vidéo](https://media.githubusercontent.com/media/claratshenge-sys/cv_clarisse/main/assets/videos/01-api-sql-backend.mp4)
   Fichier source : `api.sql - api-test - Visual Studio Code 2026-11-23 10-06-32.mp4`
2. **Présentation de l’application CV Clarisse Lodi** — [Lire la vidéo](https://media.githubusercontent.com/media/claratshenge-sys/cv_clarisse/main/assets/videos/02-cv-clarisse-lodi.mp4)
   Fichier source : `CV - Clarisse Lodi et 1 page supplémentaire - Personnel – Microsoft​ Edge 2026-11-23 09-57-24.mp4`
3. **Base de données `famille_membre` dans phpMyAdmin** — [Lire la vidéo](https://media.githubusercontent.com/media/claratshenge-sys/cv_clarisse/main/assets/videos/03-famille-membre-phpmyadmin.mp4)
   Fichier source : `localhost _ 127.0.0.1 _ api _ famille_membre _ phpMyAdmin 5.2.1 et 1 page supplémentaire - Personnel – Microsoft​ Edge 2026-11-23 10-14-29.mp4`
4. **Autres opérations de démonstration dans phpMyAdmin** — [Lire la vidéo](https://media.githubusercontent.com/media/claratshenge-sys/cv_clarisse/main/assets/videos/04-operations-phpmyadmin.mp4)
   Fichier source : `localhost _ 127.0.0.1 _ api _ famille_membre _ phpMyAdmin 5.2.1 et 1 page supplémentaire - Personnel – Microsoft​ Edge 2026-11-23 10-30-54.mp4`

## Scénario de la vidéo de démonstration

Durée suggérée : 4 à 6 minutes. Filmer les étapes suivantes avec l’API locale :

1. Montrer brièvement Apache et MySQL démarrés dans XAMPP, puis la base `api`
   dans phpMyAdmin.
2. Lancer `flutter run -d edge` et afficher l’écran de connexion.
3. S’inscrire avec un compte de démonstration dédié, puis se connecter. Ne pas
   révéler de mot de passe personnel.
4. Présenter les pages CV, Famille et Contact, et les photos locales déjà
   présentes.
5. Dans « Membres enregistrés sur le serveur », créer une fiche fictive de
   démonstration, l’ouvrir, modifier un champ, puis montrer que la liste et les
   détails reflètent les changements.
6. Supprimer cette fiche et montrer que la liste serveur est à nouveau vide.
   Si le téléversement de photo est filmé, le tester d’abord en réel avec une
   image de démonstration non personnelle.
7. Terminer en montrant brièvement `flutter test` et `flutter analyze`, puis
   préciser les limites non testées si elles n’ont pas été validées avant le
   tournage.
