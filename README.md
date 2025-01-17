# Simulation-Systeme-Transport-bus-Hanoi-avec-GAMA

## 🌟 **Présentation**
Ce projet modélise un réseau de transport urbain à hanoi (Vietnam) en utilisant des agents pour représenter les bus, les arrêts, les terminus et d'autres composants du système. Il inclut également des graphes pour simuler les itinéraires des bus et leur interaction avec les infrastructures routières.

---

## 🌟 **Objectif**
L'objectif principal est d'analyser et de simuler les flux de transport dans une ville (Hanoi pour notre cas) en tenant compte des arrêts, des lignes de bus et des interactions avec les quartiers environnants.

---

## 📌 **Fonctionnalités clés**
- **Simulation des lignes de transport** : Création et gestion de trois lignes de bus connectant différents terminus et arrêts.  
- **Graphe des routes** : Modélisation des routes et itinéraires comme graphes pour une simulation réaliste des déplacements.  
- **Interactions agents-infrastructure** : 
  - Les bus s'arrêtent aux terminus et aux arrêts en suivant des itinéraires définis.
  - Les passagers attendent les bus dans les différents arrêts et le bus les transportent aux arrêts déterminés
  - Association dynamique des arrêts et des résidences aux quartiers proches des passagers.  
- **Visualisation dynamique** : Représentation graphique en temps réel des déplacements des bus et des changements d'état.  
- **Gestion des états des bus** : Chaque bus suit un cycle logique entre les stations, le transit et l'attente.

---

## 🛠️ **Technologies utilisées**
- **Langage** : GAML (Gama Modeling Language)  
- **Modules principaux** : 
  - `graph` : Pour modéliser les itinéraires.
  - `skills: moving` : Pour simuler le mouvement des bus.  
- **Outils et bibliothèques externes** :
  - Fichiers Shape (SHP) pour intégrer des données géographiques réelles.
  - Fichiers image pour personnaliser les représentations visuelles.

---

## 📂 **Structure du projet**
```plaintext
├── models                                            # Dossier contenant le Script principal du modèle
│   ├── Systeme-Transport-bus-Hanoi-avec-GAMA.gaml    # Script principal du modèle
├── includes/                                         # Dossier contenant les fichiers annexes
│   ├── route.shp                                     # Fichier des routes
│   ├── batiment.shp                                  # Fichier des bâtiments
│   ├── arret.shp                                     # Fichier des arrêts de bus
│   ├── terminus_a.shp                                # Fichier des terminus
│   ├── ward.shp                                      # Fichier des quartiers
│   ├── line_1.shp                                    # Ligne de bus 1
│   ├── line_2.shp                                    # Ligne de bus 2
│   ├── line_3.shp                                    # Ligne de bus 3
│   └── Personne.png                                  # Image d'icône Personne
│   ├── car.png                                       # Image d'icone Voiture
│   ├── bus.png                                       # Image d'icone Bus
└── README.md                                         # Documentation du projet
```

---

## 🚀 **Installation et exécution**

### **1. Pré-requis**
- [Télécharger GAMA Platform](https://gama-platform.org/) pour exécuter les simulations.
- Avoir les fichiers `.shp` nécessaires au projet.

### **2. Installation**
1. Clonez ce dépôt :
   ```bash
   git clone https://github.com/DavidLUTALA/Simulation-Systeme-Transport-bus-Hanoi-avec-GAMA.git
   ```
2. Ouvrez GAMA Platform et exportez le projet `Systeme-Transport-bus-Hanoi-avec-GAMA`.

### **3. Exécution**
- Lancez la simulation et observez :  
  - Les bus se déplaçant entre les arrêts.
  - Les interactions entre les différents agents et infrastructures.

---

## 📝 **Fonctionnalités avancées**
- **Gestion des états des bus** : Chaque bus suit un cycle d'état (station, transit).  
- **Attribution dynamique** : Les arrêts et les résidences sont automatiquement associés aux quartiers les plus proches.  
- **Réseaux routiers** : Les itinéraires de bus sont divisés en directions aller et retour, facilitant l'analyse des flux.

---

## 📧 **Contact**
Si vous avez des questions ou suggestions, contactez-moi via [davidlutala0@gmail.com](davidlutala0@gmail.com).

---

N'hésitez pas à me contacter si vous souhaitez une collaboration ! 😊
