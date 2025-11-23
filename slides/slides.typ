#import "@preview/typslides:1.3.0": *
#import "@preview/tablex:0.0.9": *

// Project configuration
#show: typslides.with(
  ratio: "16-9",
  theme: "purply",
  font: "Fira Sans",
  font-size: 20pt,
  link-style: "color",
  show-progress: true,
)

#set raw(lang:"C", block:true)

// The front slide is the first slide of your presentation
#front-slide(
  title: "Programmation Système",
  subtitle: [24 Novembre 2025],
  authors: "Thomas Varin, Théotime Turmel, Mathias Loiseau",
  info: [#link("https://github.com/zBlxst/TP_system/")],
)

#table-of-contents()

#title-slide[Introduction à la programmation système]

#slide(title:"Introduction à la programmation système")[
  - Ensemble d’appels systèmes (syscalls)
  - Interaction directe avec le noyau
  - Gestion bas niveau : mémoire, processus, threads, fichiers
]

#title-slide[Processus]

#title-slide[Threads]

#slide(title: "Pourquoi des threads ?")[
  - Moins coûteux que les processus
  - Concurrence fine
  - Meilleure performance en multicoeurs
]

#slide(title: "La bibliothèque pthread")[
  Norme POSIX\
  Fonctions de base :
  - `pthread_create()`
  - `pthread_join()`
  - `pthread_exit()`
]

#slide(title: "Création d'un thread")[
  - Création via `int pthread_create()`
  - Le thread est affecté à une fonction `void* fun(void* args)`
  
]

#slide(title: "Terminaison d’un thread")[
  - pthread_join(thread) : attendre un thread
  - pthread_exit() : terminer explicitement
]

#slide(title: "Problèmes de concurrence")[
  - Accès simultané à une même ressource
  - Conditions de course
  - Corruption mémoire
```
void* increment(void* arg) {
  for (int i = 0; i < 1000; i++) counter++;    // Section partagée
  return NULL;
}
```
]

#slide(title: "Mutex")[
  - Verrou pour protéger une section critique
  - `pthread_mutex_lock()`
  - `pthread_mutex_unlock()`
]

#slide(title: [Exemple : tri #strike[bubulles] pair-impair])[

  #image("img/Bubble_sort_animation.gif")
  
]

#slide(title: "Récapitulatif processus vs threads")[
  #align(center)[
    #tablex(
    columns:3,
    align:center,
    hlinex(end:0),
    vlinex(end:0), [], [Processus], [Thread], vlinex(end:0),
    [Mémoire], [Séparée], [Partagée],
    [Communication], [Difficile], [Directe],
    [Isolation], [Forte], [Faible,],
    [Identité], [*PID*], [`pthread_t`],
    hlinex(end:0)
  )
  ]  
]

#title-slide[Autres aspects de Programmation Système]

#slide(title:"bit Set-User-ID (SUID)")[
  
]

#slide(title:"Sticky-bit")[
  
]

#slide(title:"Contrôle de limites système")[
  
]