#!/bin/sh
# Script de déploiement simulé pour l'épreuve EC06

echo "=== DÉPLOYEMENT SIMULÉ ==="
echo "Mise à jour de l'application..."

# Création du fichier de log
echo "=== LOGS DE DÉPLOIEMENT ===" > deploy.log
echo "Date : $(date)" >> deploy.log
echo "Étape 1 : Pull de la nouvelle image Docker..." >> deploy.log
echo "Étape 2 : Relance des conteneurs via docker-compose..." >> deploy.log
echo "Étape 3 : Exécution des migrations..." >> deploy.log
echo "Déploiement terminé avec succès !" >> deploy.log

# Affichage des logs sur la sortie standard
cat deploy.log
