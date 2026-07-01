# SkillHub API — starter EC06

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

Pour ce projet, nous mettons en place une stratégie **GitFlow simplifiée** :

- **`main`** : Branche de production. Elle est protégée pour empêcher les pushs directs. Toute modification doit passer par une Pull Request (PR) validée et testée depuis la branche `develop`.
- **`develop`** : Branche d'intégration des développements. C'est la branche de travail principale où les fonctionnalités validées sont regroupées avant d'être envoyées sur `main`.
- **`feature/<nom>`** : Branches éphémères créées à partir de `develop` pour réaliser une tâche spécifique (ex: `feature/dockerfile`, `feature/ci-pipeline`). Elles sont fusionnées dans `develop` via une Pull Request une fois les tests et la CI validés.

