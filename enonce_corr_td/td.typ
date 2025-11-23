#import "@preview/rubber-article:0.5.0": *
#import "@preview/ctheorems:1.1.3": *
#import "@preview/tablex:0.0.9": *
#show: thmrules

// Package styling
#show: article.with(
  cols: none, // Tip: use #colbreak() instead of #pagebreak() to seamlessly toggle columns
  eq-chapterwise: true,
  eq-numbering: "(1.1)",
  header-display: false,
  lang: "fr",
  page-margins: 1in,
  page-paper: "us-letter",
)

// Styling 
#show enum: set par(leading: .6em, spacing: 1em)
#set enum(numbering: "1.a.")
#show raw.where(block: true): block.with(fill: rgb("#e8e8f8"),inset: 10pt,radius: 4pt,)
#set par(justify: false)

// Correction format
#let corr = thmbox(
"corr", // identifier
"Correction ", // head
fill: rgb("#e8e8f8")
).with(numbering:none)

#let render_correction = true
#let correction(body) = {
  if render_correction {corr[#body]}
  else {}
}

#maketitle(title: "TD Système", authors: ("Thomas Varin, Théotime Turmel, Mathias Loiseau",), date: "24 Novembre 2025")

= Appels système

+ Qu'est-ce qu'un appel système ?
 #correction[]

+ Quels sont les numéros des appels système *fork/clone*, *execve*, *pipe* et *dup2* ? À quoi servent ces appels système ?
 #correction[]

+ Qu'est-ce que les commandes "builtin" ? Pourquoi existent-elles ?
 #correction[]

= Programmation d'un shell
#set raw(lang:"sh", block:true)

+ + Que fait la commande strace ? Lancer *\/bin/bash* aved l'outil *strace* (en redirigeant la sortie d'erreur dans la sortie standard)
   #correction[]
  
  +  Lancer les commandes suivantes (en tapant des commandes dans le shell) : `strace --follow-fork bash 2>\&1 | grep execve` et `strace bash 2>\&1 | grep execve`. Que remarque-t-on ?
     #correction[]

  + Lancer les commandes suivantes (en tapant des commandes dans le shell) : `strace --follow-fork bash 2>\&1 | grep clone` et `strace bash 2>\&1 | grep clone`. Que remarque-t-on ? 
     #correction[]
  Pour la suite du TP, nous utiliserons l'appel système *fork* au lieu de *clone*.

+ + En utilisant les appels systèmes *fork* et *execve*, implémenter le cas *C_PLAIN*.
     #correction[]

  + Implémenter les cas *C_AND*, *C_OR*, *C_SEQ* et *C_VOID*.
       #correction[]

  + En utilisant l’appel système *pipe*, implémenter le cas *C_PIPE*.
       #correction[]

+ En utilisant l’appel système *dup2*, implémenter les 4 cas de la fonction *apply redirects*.
     #correction[]

+ Expliquer pourquoi la commande *cd* ne peut pas être implémentée dans un binaire et appelée avec *execve*. Implémenter la commande *cd* dans la fonction.
     #correction[]

= Multithreading
#set raw(lang:"C", block:true)

+ Qu'est-ce que la *compétition* ? Comment l'éviter ?
 #correction[Une situation de compétition peut arriver quand deux threads opèrent sur les mêmes zones mémoire. Pour l'éviter, on peut utiliser l'exclusion mutuelle, qui permet de tout simplement réserver une zone mémoire à un processus tant qu'il l'utilise.]

+ Quels sont les avantages et les inconvénients des threads par rapport aux processus ?
 #correction[Les threads peuvent communiquer simplement car leur mémoire est partagée et consomment moins mais sont susceptibles à la *compétition* et à l'*interblocage*.]

+ Implémentons le tri pair-impair en C. Le principe est de comparer dans un premier temps les couples $(x_0,x_1), (x_2,x_3), ... $ en échangeant éventuellement leurs éléments si $x_i > x_(i+1)$ (phase paire), puis de faire la même chose pour $(x_1, x_2), (x_3, x_4), ...$ jusqu'à ce que le tableau soit  trié.

  + Combien de threads au plus est-il utile d'avoir ?
    #correction[Soit un tableau de taille $n$ : 
  - Si $n$ est pair, la phase paire effectuera $n/2$ comparaisons, et la phase impaire $n/2 - 1$.
  - Si $n$ est impair, les deux phases effectueront $(n-1)/2$ comparaisons.
  Bref, il est utile d'avoir au plus $floor(n/2)$ threads] 

  + Soit $T$ un tableau de taille $n$ et $p$ threads $t_i,  forall i in [|0,p-1|]$. Comment répartir les comparaisons et faire en sorte qu'aucune comparaison ne soit faite deux fois ?
    #correction[Il suffit de faire démarrer le thread $t_i$ à l'indice $2i$ ($2i+1$ pour une phase impaire), de comparer l'élément à cet indice avec le suivant, puis d'incrémenter de $2p$ indices. On répète jusqu'à atteindre $n-1$.\
    #underline[Remarque] : si $n$ pair, le dernier thread n'a rien à faire en phase impaire]

  + On donnera aux threads la structure suivante : ```
typedef struct {
  int phase; // 0 ou 1
  int thread_id;
  int num_threads;
  int *arr;
  int len;
} thread_data_t;
``` Implémenter `swap(int *a, int *b)`\
    et `void* phase_thread (void* arg) {
      thread_data_t* data = (thread_data_t*)arg;
      ...
      return NULL;
  }`
    #correction[``` void swap(int *a, int *b) {
      int temp = *a;
      *a = *b;
      *b = temp;
}
void* phase_thread(void* arg) {
    thread_data_t* data = (thread_data_t*)arg;
    int phase = data->phase;
    int thread_id = data->thread_id;
    int num_threads = data->num_threads;
    int* a = data->arr;
    int n = data->len;
    for (int i = thread_id * 2 + phase;; i < n - 1; i += num_threads * 2) {
        if (a[i] > a[i + 1]) swap(&a[i], &a[i + 1]);
    }
    return NULL;
}
```]

  + On peut montrer qu'il faut au plus $n$ itérations (ie $2n$ phases). Implémenter `void tri_pairimpair(int* a_arr, int n_arr)`
    #correction[
      ``` void tri_pairimpair(int* a, int n) {
    int num_threads = nb_threads(n);
    pthread_t threads[num_threads];
    thread_data_t thread_data[num_threads];
    int iteration = 0;
    while (iteration < n) {
        for (int phase = 0; phase <= 1; phase++) {
            for (int i = 0; i < num_threads; i++) {
                thread_data[i].phase = phase;
                thread_data[i].thread_id = i;
                thread_data[i].num_threads = num_threads;
                thread_data[i].arr = a;
                thread_data[i].len = n;
                pthread_create(&threads[i], NULL, phase_thread, &thread_data[i]);
            }
            for (int i = 0; i < num_threads; i++) pthread_join(threads[i], NULL);
            iteration++;
        }
    }
}```
    ]

  + Comment peut-on savoir plus tôt si le tableau est trié ?
    #correction[On peut ajouter une variable `swapped` dans `thread_data_t`, que les threads passent à 1 s'ils effectuent un swap, et si on remarque au bout d'une itération (ie une phase paire puis une phase impaire) que `swapped` est toujours à 0, on peut s'arrêter. \
    #underline[Remarque] : techniquement, le comportement où deux threads écrivent au même moment sur la même variable n'est pas défini dans la norme C. On pourrait en faire un `atomic_int`
  ]

= Set-user-ID bit
+ Que se passe-t'il lorsqu'un utilisateur exécute un programme marqué avec le bit Set-user-ID ?
  #correction[Son euid (Effective User ID) devient celle du propriétaire du fichier.]

+ Quelles commandes faut-il taper afin d'activer/désactiver le bit Set-User-ID pour un fichier exécutable ?
  #correction[La commande ``` chmod u+s filename``` active le bit SUID tandis que ``` chmod u-s filename ``` le désactive.]

+ Copiez le code C suivant dans un fichier psudo.c et sauvegardez le fichier Makefile donné juste après

  psudo.c
    ``` #include <stdio.h>
  #include <unistd.h>
  
  void print_usage() {
    printf("USAGE: psudo cmd\n");
    printf("\t cmd contient la commande \n");
    printf("EXEMPLE:\n");
    printf("\t psudo cat psudo.c\n");
    printf("\t psudo whoami\n");
    printf("\t psudo apt install\n");
  }
  
  int main(int argc, char *argv[]) {  
    if (2 > argc) {
      print_usage();
      return 1;
    }
    // TODO: Manipuler le real id pour utiliser des commandes qui normalement nécessitent sudo (ex: apt install)
  
    // FIN 
    execvp(argv[1], argv + 1);
    return 0;
  }
  ```

  Makefile
  ```
  CC=gcc
  SRC=psudo.c
  
  all:
  	${CC} ${SRC} -o psudo
  	chmod 777 psudo
  	chmod u+s psudo
  	sudo -k
  ```
    + Que fait la commade sudo -k ?
      #correction[Normalement, après un sudo réussi par un utilisateur, un timer s'exécute. Tant que ce timer n'atteint pas 0, toute autre commande sudo du même utilisateur dans la même session ne nécessitera pas de taper de mot de passe.
  
      ``` sudo -k ``` permet de supprimer les infos d'authentification. Le prochain appel à une commande privilégiée nécessitera donc de retaper le mot de passe. ]

    + Compilez ce programme en tant que root (ex: ``` sudo make ```). Vous devriez obtenir un programme appelé "psudo" dont le propriétaire est root, avec le bit Set-User-ID activé.
      Complétez ce programme pour pouvoir exécuter un programme en tant que root sans avoir besoin de vous authentifier (ex: apt install)
        #correction[``` int euid = geteuid();
        setuid(euid);
        ```]
= Limites de ressources pour les processus
  + Créez un simple programme C pour obtenir les valeurs de différentes limites pour le processus en utilisant la fonction ``` getrlimit()```.
    #correction[```#include <stdio.h>
#include <sys/resource.h>
#include <unistd.h>

#define STR(A) #A

#define GETLIMIT(A)                                     \
  getrlimit(RLIMIT_##A, &limit);                        \
  printf("%s = %lu : %lu\n", STR(RLIMIT_ ## A),         \
     limit.rlim_cur, limit.rlim_max);                   \
  
int main() {
  struct rlimit limit;
  GETLIMIT(AS)
  GETLIMIT(CORE)
  GETLIMIT(CPU)
  GETLIMIT(DATA)
  GETLIMIT(FSIZE)
  GETLIMIT(MEMLOCK)
  GETLIMIT(MSGQUEUE)
  GETLIMIT(NICE)
  GETLIMIT(NPROC)
  GETLIMIT(RSS)
  GETLIMIT(SIGPENDING)
  GETLIMIT(STACK)
}

```]