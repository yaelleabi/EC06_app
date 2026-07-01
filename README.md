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

Pour ce projet, nous mettons en place une stratégie **GitFlow simplifiée**. 

### Justification de la stratégie
Le choix de GitFlow simplifiée se justifie par le besoin d'avoir une séparation claire entre la production (`main`), la branche d'intégration de développement (`develop`), et les tâches en cours (`feature/*`). Cela permet de garantir que la branche `main` reste toujours stable et testée, tout en permettant aux développeurs de travailler de manière isolée sur leurs fonctionnalités avant de les intégrer.

### Structure des branches
- **`main`** : Branche de production. Elle contient le code stable et prêt à être déployé. Tout push direct y est interdit.
- **`develop`** : Branche principale de développement et d'intégration. Les fonctionnalités terminées et testées y sont fusionnées.
- **`feature/<nom>`** : Branches éphémères créées depuis `develop` pour le développement d'une fonctionnalité spécifique (ex : `feature/dockerfile`, `feature/ci-pipeline`). Elles sont ensuite fusionnées dans `develop` via une Pull Request (PR).

### Protection de la branche `main`
La branche `main` est configurée avec les règles de protection suivantes sur GitHub (décrites ici à défaut de pouvoir être totalement appliquées sans droits administrateur avancés) :
1. **Require a pull request before merging** : Interdiction de push directement sur `main`. Tout changement doit obligatoirement faire l'objet d'une Pull Request (PR).
2. **Require status checks to pass before merging** : Les jobs de lint et de tests de la CI doivent obligatoirement être au vert (success) avant de pouvoir fusionner la PR.
3. **Restrict who can push to matching branches** : Seuls les administrateurs et leads du projet peuvent fusionner la PR une fois toutes les conditions remplies.


