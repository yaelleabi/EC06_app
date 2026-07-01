# SkillHub API — starter EC06

[![CI/CD Pipeline](https://github.com/yaelleabi/EC06_app/actions/workflows/ci.yml/badge.svg)](https://github.com/yaelleabi/EC06_app/actions/workflows/ci.yml)

Mini API Express (Node.js 20) qui sert de base à l'épreuve EC06.

## Endpoints

- `GET /` : message d'accueil.
- `GET /health` : retourne le statut de l'API.

## Scripts npm

```bash
npm install            # installer les dépendances
npm start              # démarrer le serveur sur le port 3000
npm test               # lancer la suite de tests Jest
npm run lint           # vérifier le code avec ESLint
```

## À noter

Ce starter contient une mini-app Express fonctionnelle, **2 tests Jest qui passent**, et une config ESLint minimale. **Tout passe au vert dès le départ** — l'épreuve évalue votre capacité à mettre en place la chaîne CI/CD autour de cette app, pas à coder en Node.

Ce starter ne contient **ni** `Dockerfile`, **ni** `docker-compose.yml`, **ni** `.gitignore`, **ni** workflow CI. C'est à vous de tout ajouter pendant l'épreuve.

## Pré-requis

- Node.js 20+
- Docker et Docker Compose (à utiliser une fois que vous aurez écrit votre `Dockerfile` et `docker-compose.yml`)

## Stratégie de branches (GitFlow)

Pour ce projet, nous mettons en place une stratégie **GitFlow simplifiée**.

### Justification de la stratégie

Le choix de GitFlow simplifiée se justifie par le besoin d'avoir une séparation claire entre la production (`main`), la branche d'intégration de développement (`develop`), et les tâches en cours (`feature/*`). Cela permet de garantir que la branche `main` reste toujours stable et testée, tout en permettant aux développeurs de travailler de manière isolée sur leurs fonctionnalités avant de les intégrer.

### Structure des branches

- **`main`** : Branche de production. Elle contient le code stable et prêt à être déployé. Tout push direct y est interdit.
- **`develop`** : Branche principale de développement et d'intégration. Les fonctionnalités terminées et testées y sont fusionnées.
- **`feature/<nom>`** : Branches éphémères créées depuis `develop`. Elles sont ensuite fusionnées dans `develop` .

## Conteneurisation (Docker)

### Description du Dockerfile Multi-stage

Notre `Dockerfile` est structuré en deux étapes pour optimiser la sécurité et la taille de l'image finale :

1. **Étape `builder`** : Utilise l'image `node:20-alpine` pour copier les fichiers du projet et exécuter `npm ci`, installant ainsi toutes les dépendances (y compris les outils de test et de lint requis pour la CI).
2. **Étape finale** : Utilise également `node:20-alpine` pour une légèreté maximale (taille finale d'environ 50 Mo, bien en dessous du bonus de 200 Mo). Elle n'installe que les dépendances de production (`npm ci --only=production`) et récupère uniquement le code source nécessaire (`/src`) depuis le constructeur.
   - **Utilisateur non-root** : L'instruction `USER node` est explicitement déclarée pour exécuter le conteneur avec des privilèges restreints.
   - **Exposition du port** : Le port `3000` est exposé via l'instruction `EXPOSE 3000`.
   - **HEALTHCHECK** : Défini via `wget` pour tester périodiquement l'état de l'endpoint `/health` :
     `

### Description de docker-compose

Le fichier `docker-compose.yml` permet de démarrer l'ensemble de la stack locale avec la commande `docker compose up`. Il comprend :

- **`app`** : Le service Node.js construit localement à partir du `Dockerfile`, exposant le port configuré via la variable `PORT` (par défaut 3000) et dépendant du démarrage sain (`service_healthy`) de la base de données.
- **`db`** : Un conteneur PostgreSQL (`postgres:15-alpine`) intégrant un test de santé (`pg_isready`) et des variables d'environnement configurées via un fichier `.env`.
- **Persistance** : Un volume nommé `pgdata` monté sur `/var/lib/postgresql/data` pour conserver les données de la base de données après l'arrêt des conteneurs.
- **Gestion de la configuration** : Chargement des variables d'environnement via la directive `env_file` pointant sur `.env`. Le fichier `.env` est ignoré par Git (défini dans `.gitignore`), tandis qu'un modèle `.env.dist` est versionné.

## Architecture du Pipeline CI/CD

Le pipeline CI/CD est implémenté avec **GitHub Actions** (`.github/workflows/ci.yml`) et s'articule autour de trois jobs : `quality`, `build` et `deploy`.

Ce pipeline s'exécute automatiquement lors de chaque modification poussée sur le dépôt ou lors de l'ouverture d'une Pull Request. Il permet de garantir en continu que le code respecte les standards de qualité, d'analyser la sécurité de l'image de production et d'automatiser le déploiement final lorsque les modifications sont validées sur la branche principale.

### Détails des jobs

1. **Quality (Lint + Test)** :
   - S'exécute sur toutes les branches à chaque push et Pull Request.
   - Initialise le fichier `.env` à partir de `.env.dist`.
   - Lance ESLint et Jest **à l'intérieur du conteneur Docker** via `docker compose run --rm app`.
   - Exporte et publie les logs de tests comme artefact GitHub (`test-results`).
2. **Build & Scan** :
   - S'exécute uniquement si le job `quality` réussit.
   - Construit l'image Docker de production et la charge localement.
   - **Scan de sécurité (Trivy)** : Utilise l'action `aquasecurity/trivy-action` pour scanner l'image à la recherche de failles de sécurité de niveau `HIGH` et `CRITICAL`.
   - Si le scan réussit et que le déclencheur est sur la branche `main`, pousse l'image sur Docker Hub avec les tags (SHA court et `latest`).
3. **Deploy** :
   - Déclenché uniquement sur la branche `main` après réussite du build.
   - Exécute le script `deploy.sh` qui simule le déploiement local de l'application et exporte le fichier `deploy.log` comme artefact.
