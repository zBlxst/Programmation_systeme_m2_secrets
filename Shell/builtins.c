#include "builtins.h"

#include "main.h"
#include "bubulles.h"

#include <sys/types.h>
#include <pwd.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>

int builtin_cd(struct cmd* cmd) {
    if (cmd->args[1] == NULL) {
        if (chdir(getpwuid(getuid())->pw_dir) == -1) {
            printf("Cannot access %s\n", getpwuid(getuid())->pw_dir);
            return -2;
        }
    } else {
        if (chdir(cmd->args[1]) == -1) {
            printf("Cannot access %s\n", cmd->args[1]);
            return -2;
        }
    }
    return 0;
}

int builtin_exit(struct cmd* cmd) {
    if (!cmd->args[1]) {
        exit_shell(0);
    }
    exit_shell(atoi(cmd->args[1]));
    return 0;
}

int builtin_bubulles(struct cmd* cmd) {
    if (!cmd->args[1]) {
        return bubulles_test();
    }
    if (strcmp(cmd->args[1], "-v") == 0) {
        if (!cmd->args[2]) {
            printf("Usage: bubulles (-v) <filename>\n");
            return -2;
        }
        return bubulles_sort_file(cmd->args[2], 1);
    }
    return bubulles_sort_file(cmd->args[1], 0);
}