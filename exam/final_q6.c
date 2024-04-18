#include <string.h>
#include <stdlib.h>

/**
 * given a `UTF-8` encoded string,
 * return a new string that is only
 * the characters within the provided range.
 *
 * Note:
 * `range_start` is INCLUSIVE
 * `range_end`   is EXCLUSIVE
 *
 * eg:
 * "hello world", 0, 5
 * would return "hello"
 *
 * "🍓🍇🍈🍍🍐", 2, 5
 * would return "🍈🍍🍐"
**/

char *final_q6(char *utf8_string, unsigned int range_start, unsigned int range_end) {
	char *new_string = strdup(utf8_string);
	int len = strlen(new_string);
	for (int i = 0; i < range_start && i < len; i++) {
		for (int j = i; j < len; j++) {
			new_string[j] = new_string[j + 1];
		}
		len--;
		i--;
	}
	len = strlen(new_string);
	if (range_end > len) {
		range_end = len;
	}
	char *result = strndup(new_string, range_end);
	return result;
}
