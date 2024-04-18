////////////////////////////////////////////////////////////////////////
// COMP1521 22T2 --- Assignment 2: `bytelocker', a simple file encryptor
// <https://www.cse.unsw.edu.au/~cs1521/22T2/assignments/ass2/index.html>
//
// Written by Phot Koseekrainiramon on 07/08/2022.
//
// 2022-07-22   v1.2    Team COMP1521 <cs1521 at cse.unsw.edu.au>

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>
#include <dirent.h>

#include "bytelocker.h"

// Helper functions
static void printPermission(struct stat s);

char *generate_random_string(int seed);
void sort_by_count(struct text_find *files, size_t n);
void sort_by_name(char *filenames[], size_t num_files);

// Some provided strings which you may find useful. Do not modify.
const char *const MSG_ERROR_FILE_STAT  = "Could not stat file\n";
const char *const MSG_ERROR_FILE_OPEN  = "Could not open file\n";
const char *const MSG_ERROR_CHANGE_DIR = "Could not change directory\n";
const char *const MSG_ERROR_DIRECTORY  =
    "%s cannot be encrypted: bytelocker does not support encrypting directories.\n";
const char *const MSG_ERROR_READ       =
    "%s cannot be encrypted: group does not have permission to read this file.\n";
const char *const MSG_ERROR_WRITE      =
    "%s cannot be encrypted: group does not have permission to write here.\n";
const char *const MSG_ERROR_SEARCH     = "Please enter a search string.\n";
const char *const MSG_ERROR_RESERVED   =
    "'.' and '..' are reserved filenames, please search for something else.\n";


//////////////////////////////////////////////
//                                          //
//              SUBSET 0                    //
//                                          //
//////////////////////////////////////////////

//
//  Read the file permissions of the current directory and print them to stdout.
//
void show_perms(char filename[MAX_PATH_LEN]) {
    struct stat s;
    if (stat(filename, &s) != 0) {
        printf(MSG_ERROR_FILE_STAT);
        return;
    }
    printf("%s: ", filename);
    printPermission(s);
    printf("\n");
    return;
}

//
//  Prints current working directory to stdout.
//
void print_current_directory(void) {
    char pathname[MAX_PATH_LEN];
    if (getcwd(pathname, sizeof pathname) == NULL) {
        perror("getcwd");
        exit(1);
    }
    printf("Current directory is: ");
    printf("%s\n", pathname);

    return;
}

//
//  Changes directory to the given path.
//
void change_directory(char dest_directory[MAX_PATH_LEN]) {
    // if dest_directory start with ~ then get path using getenv,
    // and changing to that path
    if (dest_directory[0] == '~') {
        char *home = getenv("HOME");
        char path[MAX_PATH_LEN];
        strcpy(path, home);
        dest_directory++;
        strcat(path, dest_directory);
        if (chdir(dest_directory) != 0) {
            char pathname[MAX_PATH_LEN];
            while (1) {
                if (getcwd(pathname, sizeof pathname) == NULL) {
                    perror("getcwd");
                    exit(1);
                }
                if (chdir(path) == 0) {
                    printf("Moving to %s\n", path);
                    return;
                }
                if (strcmp(pathname, "/") == 0) {
                    break;
                }
                if (chdir("..") != 0) {
                    perror("chdir");
                    exit(1);
                }
            }
            printf(MSG_ERROR_CHANGE_DIR);
            return;
        }
    } else if (chdir(dest_directory) != 0) {
        printf(MSG_ERROR_CHANGE_DIR);
        return;
    }
    printf("Moving to %s\n", dest_directory);
    return;
}

//
//  Lists the contents of the current directory to stdout.
//
void list_current_directory(void) {
    char pathname[MAX_PATH_LEN];
    if (getcwd(pathname, sizeof pathname) == NULL) {
        perror("getcwd");
        exit(1);
    }
    struct dirent *entry;
    DIR *dir = opendir(pathname);
    if (dir == NULL) {
        perror("dir");
        exit(1);
    }
    char *filename[FILENAME_MAX];
    int numFilename = 0;
    // loop through all files in the directory
    while ((entry = readdir(dir)) != NULL) {
        filename[numFilename++] = entry->d_name;
    }
    sort_by_name(filename, numFilename);
    for (int i = 0; i < numFilename; i++) {
        struct stat s;
        if (stat(filename[i], &s) != 0) {
            printf(MSG_ERROR_FILE_STAT);
            return;
        }
        printPermission(s);
        printf("	%s\n", filename[i]);
    }
    closedir(dir);
    return;
}


//////////////////////////////////////////////
//                                          //
//              SUBSET 1                    //
//                                          //
//////////////////////////////////////////////
// checking if a file can be encrypted
bool test_can_encrypt(char filename[MAX_PATH_LEN]) {
    struct stat s;
    // if the file exists
    if (stat(filename, &s) != 0) {
        printf(MSG_ERROR_FILE_STAT);
        return false;
    // if it is regular
    } else if (S_ISDIR(s.st_mode)) {
        printf(MSG_ERROR_DIRECTORY, filename);
        return false;
    // if the group is able to read
    } else if (!(s.st_mode &S_IRGRP)) {
        printf(MSG_ERROR_READ, filename);
        return false;
    // if the group is able to write
    } else if (!(s.st_mode &S_IWGRP)) {
        printf(MSG_ERROR_WRITE, filename);
        return false;
    }
    return true;
}

// XORs each byte with 0xFF and put result into a new file .xor
void simple_xor_encryption(char filename[MAX_PATH_LEN]) {
    if (!test_can_encrypt(filename)) return;

    FILE *input_stream = fopen(filename, "r");
    if (input_stream == NULL) {
        perror(filename);
        exit(1);
    }
    char ch[5] = ".xor";
    strcat(filename, ch);
    FILE *output_stream = fopen(filename, "w");
    if (input_stream == NULL) {
        perror(filename);
        exit(1);
    }
    int c = fgetc(input_stream);
    // xor input and put result in the output file
    while (c != EOF) {
        fputc((c ^ 0xFF), output_stream);
        c = fgetc(input_stream);
    }
    fclose(input_stream);
    fclose(output_stream);
    return;
}

// XORs each byte with 0xFF and put result into a new file .dec
void simple_xor_decryption(char filename[MAX_PATH_LEN]) {
    if (!test_can_encrypt(filename)) return;

    FILE *input_stream = fopen(filename, "r");
    if (input_stream == NULL) {
        perror(filename);
        exit(1);
    }
    char ch[5] = ".dec";
    strcat(filename, ch);
    FILE *output_stream = fopen(filename, "w");
    if (input_stream == NULL) {
        perror(filename);
        exit(1);
    }
    int c = fgetc(input_stream);
    // xor input and put result in the output file
    while (c != EOF) {
        fputc((c ^ 0xFF), output_stream);
        c = fgetc(input_stream);
    }
    fclose(input_stream);
    fclose(output_stream);
    return;
}


//////////////////////////////////////////////
//                                          //
//              SUBSET 2                    //
//                                          //
//////////////////////////////////////////////
// searching into a directory and it's subdirectories for a file 
// having a given string as subset
void search_by_filename(char filename[MAX_SEARCH_LENGTH]) {
    // error if given string is empty or . or ..
    if (filename[0] == '\0') {
        printf(MSG_ERROR_SEARCH);
        return;
    } else if ((filename[0] == '.' && filename[1] == '\0') ||
               (filename[0] == '.' && filename[1] == '.' &&
               filename[2] == '\0')) {
        printf(MSG_ERROR_RESERVED);
        return;
    }

    char pathname[MAX_PATH_LEN];
    if (getcwd(pathname, sizeof pathname) == NULL) {
        perror("getcwd");
        exit(1);
    }
    struct dirent *entry;
    DIR *dir = opendir(pathname);
    if (dir == NULL) {
        perror("dir");
        exit(1);
    }
    char *filenames[FILENAME_MAX];
    int numFilenames = 0;
    // loop through all files and push into filenames array 
    while ((entry = readdir(dir)) != NULL) {
        if (strstr(entry->d_name, filename)) {
            filenames[numFilenames++] = entry->d_name;
        }
    }
    if (numFilenames == 0) {
        printf("\n");
        return;
    }
    // sort by name and print them all
    sort_by_name(filenames, numFilenames);
    for (int i = 0; i < numFilenames; i++) {
        struct stat s;
        if (stat(filenames[i], &s) != 0) {
            printf(MSG_ERROR_FILE_STAT);
            return;
        }
        printPermission(s);
        printf("	./%s\n", filenames[i]);
    }
    return;
}

// searching into a directory and it's subdirectories for a file 
// having a given string in their contents
void search_by_text(char text[MAX_SEARCH_LENGTH]) {
    // error if a given string is empty
    if (text[0] == '\0') {
        printf(MSG_ERROR_SEARCH);
        return;
    }

    return;
}


//////////////////////////////////////////////
//                                          //
//              SUBSET 3                    //
//                                          //
//////////////////////////////////////////////
void electronic_codebook_encryption(char filename[MAX_PATH_LEN], char password[CIPHER_BLOCK_SIZE + 1]) {
    if (!test_can_encrypt(filename)) return;
    
    printf("TODO: COMPLETE ME\n");
    exit(1);
}

void electronic_codebook_decryption(char filename[MAX_PATH_LEN], char password[CIPHER_BLOCK_SIZE + 1]) {
    if (!test_can_encrypt(filename)) return;

    printf("TODO: COMPLETE ME\n");
    exit(1);
}

char *shift_encrypt(char *plaintext, char *password) {
    printf("TODO: COMPLETE ME\n");
    exit(1);
    return NULL;
}

char *shift_decrypt(char *ciphertext, char *password) {
    printf("TODO: COMPLETE ME\n");
    exit(1);
    return NULL;
}


//////////////////////////////////////////////
//                                          //
//              SUBSET 4                    //
//                                          //
//////////////////////////////////////////////
void cyclic_block_shift_encryption(char filename[MAX_PATH_LEN], char password[CIPHER_BLOCK_SIZE + 1]) {
    if (!test_can_encrypt(filename)) return;
    
    printf("TODO: COMPLETE ME\n");
    exit(1);
}

void cyclic_block_shift_decryption(char filename[MAX_PATH_LEN], char password[CIPHER_BLOCK_SIZE + 1]) {
    if (!test_can_encrypt(filename)) return;
    
    printf("TODO: COMPLETE ME\n");
    exit(1);
}


// PROVIDED FUNCTIONS, DO NOT MODIFY

// Generates a random string of length RAND_STR_LEN.
// Requires a seed for the random number generator.
// The same seed will always generate the same string.
// The string contains only lowercase + uppercase letters,
// and digits 0 through 9.
// The string is returned in heap-allocated memory,
// and must be freed by the caller.
char *generate_random_string(int seed) {
    if (seed != 0) {
        srand(seed);
    }

    char *alpha_num_str =
            "abcdefghijklmnopqrstuvwxyz"
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            "0123456789";

    char *random_str = malloc(RAND_STR_LEN);

    for (int i = 0; i < RAND_STR_LEN; i++) {
        random_str[i] = alpha_num_str[rand() % (strlen(alpha_num_str) - 1)];
    }

    return random_str;
}

// Sorts the given array (in-place) of files with
// associated counts into descending order of counts.
// You must provide the size of the array as argument `n`.
void sort_by_count(struct text_find *files, size_t n) {
    if (n == 0 || n == 1) return;
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (files[j].count < files[j + 1].count) {
                struct text_find temp = files[j];
                files[j] = files[j + 1];
                files[j + 1] = temp;
            } else if (files[j].count == files[j + 1].count && strcmp(files[j].path, files[j + 1].path) > 0) {
                struct text_find temp = files[j];
                files[j] = files[j + 1];
                files[j + 1] = temp;
            }
        }
    }
}

// Sorts the given array (in-place) of strings alphabetically.
// You must provide the size of the array as argument `n`.
void sort_by_name(char *filenames[], size_t num_filenames) {
    if (num_filenames == 0 || num_filenames == 1) return;
    for (int i = 0; i < num_filenames - 1; i++) {
        for (int j = 0; j < num_filenames - i - 1; j++) {
            if (strcmp(filenames[j], filenames[j + 1]) > 0) {
                char *temp = filenames[j];
                filenames[j] = filenames[j + 1];
                filenames[j + 1] = temp;
            }
        }
    }
}

// Helper functions

// printing file's permission
static void printPermission(struct stat s) {
    printf((S_ISDIR(s.st_mode)) ? "d" : "-");
    printf((s.st_mode &S_IRUSR) ? "r" : "-");
    printf((s.st_mode &S_IWUSR) ? "w" : "-");
    printf((s.st_mode &S_IXUSR) ? "x" : "-");
    printf((s.st_mode &S_IRGRP) ? "r" : "-");
    printf((s.st_mode &S_IWGRP) ? "w" : "-");
    printf((s.st_mode &S_IXGRP) ? "x" : "-");
    printf((s.st_mode &S_IROTH) ? "r" : "-");
    printf((s.st_mode &S_IWOTH) ? "w" : "-");
    printf((s.st_mode &S_IXOTH) ? "x" : "-");
    return;
}
