#include "main.h"
#include "constants.h"

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <readline/readline.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <pwd.h>
#include <string.h>
#include <readline/readline.h>

void print_indent(int indent) {
	for (int i = 0; i < indent; i++) {
		printf("  ");
	}
}

void debug_print(struct cmd *cmd, int indent) {
	switch (cmd->type)
	{
	    case C_PLAIN:
			print_indent(indent);
			printf("C_PLAIN :\n");
			for (int i = 0; cmd->args[i]; i++) {
				print_indent(indent+1);
				printf("cmd->arg[%d] : %s\n", i, cmd->args[i]);
			}
			break;
		case C_SEQ:
			print_indent(indent);
			printf("C_SEQ :\n");
			print_indent(indent+1);
			printf("Left :\n");
			debug_print(cmd->left, indent+2);
			print_indent(indent+1);
			printf("Rigth :\n");
			debug_print(cmd->right, indent+2);
			break;
		case C_AND:
	    	print_indent(indent);
			printf("C_AND :\n");
			print_indent(indent+1);
			printf("Left :\n");
			debug_print(cmd->left, indent+2);
			print_indent(indent+1);
			printf("Rigth :\n");
			debug_print(cmd->right, indent+2);
			break;
		case C_OR:
	    	print_indent(indent);
			printf("C_OR :\n");
			print_indent(indent+1);
			printf("Left :\n");
			debug_print(cmd->left, indent+2);
			print_indent(indent+1);
			printf("Rigth :\n");
			debug_print(cmd->right, indent+2);
			break;
		case C_PIPE:
			print_indent(indent);
			printf("C_PIPE :\n");
			print_indent(indent+1);
			printf("Left :\n");
			debug_print(cmd->left, indent+2);
			print_indent(indent+1);
			printf("Rigth :\n");
			debug_print(cmd->right, indent+2);
			break;
		case C_VOID:
			print_indent(indent);
			printf("C_VOID :\n");
			print_indent(indent+1);
			printf("Left :\n");
			debug_print(cmd->left, indent+2);
			break;
		default: 
			return;
	}
	print_indent(indent+1);
	printf("Input : %s\n", cmd->input);
	print_indent(indent+1);
	printf("Output : %s\n", cmd->output);
	print_indent(indent+1);
	printf("Append : %s\n", cmd->append);
	print_indent(indent+1);
	printf("Error : %s\n", cmd->error);
}

void apply_redirects(struct cmd *cmd) {
	if (cmd->input || cmd->output || cmd->append || cmd->error)
	{
		if (cmd->input) {
			// TODO
		}
		if (cmd->output) {
			// TODO
		}
		if (cmd->append) {
			// TODO
		}
		if (cmd->error) {
			// TODO
		}
	}
}

int execute_builtin(struct cmd *cmd) {
	// TODO
	return NOT_BUILTIN;
}

int execute(struct cmd *cmd) {
	switch (cmd->type)
	{
	    case C_PLAIN:
			// TODO
		case C_SEQ:
			// TODO
		case C_AND:
	    	// TODO
		case C_OR:
	    	// TODO
		case C_PIPE:
			// TODO
		case C_VOID:
			// TODO
		default:
			printf("I don't know how to handle that !\n");
			return -1;
	}
}

int exit_shell(int status) {
	exit(status);
}

int main(int argc, char **argv) {
	printf("Welcome to zblxst's shell!\n");
	char prompt[] = "> ";

	while (1)
	{
		char* line = readline(prompt);
		if (!line) exit_shell(0);
		if (!*line) continue;
				

		struct cmd *cmd = parser(line);
		if (!cmd) continue;
		if (DEBUG) debug_print(cmd, 0);
		execute(cmd);
	}
}
