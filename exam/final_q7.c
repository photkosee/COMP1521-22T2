#include <string.h>
#include <dirent.h>
#include <stdio.h>

/**
 * Recursively find all files and directories
 * in `directory` that match the given criteria.
 *
 * Parameters:
 * `directory`: The starting directory to begin
 *              the search. This parameter will
 *              always be provided (i.e. never NULL).
 * 
 * `name`:      If provided, any printed files or
 *              directories must have this name.
 *              Note that you should still search through
 *              directories that do not match `name`.
 *              If not provided (i.e. name == NULL),
 *              there are no restrictions on the name.
 *
 * `min_depth`: If provided, any printed files or
 *              directories must occur at least `min_depth`
 *              directories deep.
 *              Any files or directories existing in the
 *              provided `directory` are considered to be
 *              of depth 0.
 *              If not provided (i.e. min_depth == -1),
 *              there are no restrictions on minimum depth.
 *
 * `max_depth`: If provided, any printed files or
 *              directories must occur at most `max_depth`
 *              directories deep.
 *              Any files or directories existing in the
 *              provided `directory` are considered to be
 *              of depth 0.
 *              If not provided (i.e. max_depth == -1),
 *              there are no restrictions on maximum depth.
 */
void final_q7(char *directory, char *name, int min_depth, int max_depth) {
	char path[1024];
	DIR *dir = opendir(directory);
	if (dir == NULL) {
		return;
	}

	struct dirent *entry;
	while ((entry = readdir(dir)) != NULL) {
		int min = min_depth;
		int max = max_depth;
		if (strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0) {
			if (name == NULL && min <= -1 && max <= -1) {
				printf("%s\n", entry->d_name);
			} else if (name != NULL && strcmp(entry->d_name, name) == 0 &&
									min <= -1 && max <= -1) {
				printf("%s\n", entry->d_name);
			}

			strcpy(path, directory);
			strcat(path, "/");
			strcat(path, entry->d_name);
			max--;
			min--;
			final_q7(path, name, min, max);
		}
	}

	closedir(dir);
}
