/**
 * test.c - A test file for CSSE2310/CSSE7231 C style requirements
 *
 * This file demonstrates various C language constructs that will trigger
 * clangd LSP features and style checking. It follows the WebKit-based style
 * with the additional CSSE requirements.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Constants should be UPPER_CASE per style guide
#define MAX_BUFFER_SIZE 1024
#define ERROR_CODE_INVALID_INPUT 1
#define ERROR_CODE_FILE_NOT_FOUND 2

// Function prototype - camelBack naming convention
int processInput(const char *inputString, int maxLength);
char *createFormattedOutput(const char *input, int count);

/**
 * Struct with appropriate style
 */
typedef struct {
    int id;
    char *name;
    double value;
} DataPoint;

/**
 * Main function that demonstrates style requirements
 */
int main(int argc, char **argv) {
    // Variable declarations - camelBack naming
    int returnCode = 0;
    char inputBuffer[MAX_BUFFER_SIZE];
    DataPoint *dataPoints = NULL;

    // Check arguments
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <input_string>\n", argv[0]);
        return ERROR_CODE_INVALID_INPUT;
    }

    // Copy input with bounds checking
    if (strlen(argv[1]) >= MAX_BUFFER_SIZE) {
        fprintf(stderr, "Input too long (max %d characters)\n",
                MAX_BUFFER_SIZE - 1);
        return ERROR_CODE_INVALID_INPUT;
    }

    // Proper control structure formatting
    strncpy(inputBuffer, argv[1], MAX_BUFFER_SIZE - 1);
    inputBuffer[MAX_BUFFER_SIZE - 1] = '\0';

    // Function call
    int count = processInput(inputBuffer, MAX_BUFFER_SIZE);

    // Conditional with proper formatting
    if (count > 0) {
        char *output = createFormattedOutput(inputBuffer, count);
        if (output) {
            printf("Processed output: %s\n", output);
            free(output);
        } else {
            fprintf(stderr, "Failed to create output\n");
            returnCode = ERROR_CODE_INVALID_INPUT;
        }
    } else {
        // Multi-line comment that demonstrates proper indentation
        /* This is a multi-line comment
         * that follows the style guide with
         * proper indentation and alignment.
         */
        fprintf(stderr, "Processing failed with count: %d\n", count);
        returnCode = ERROR_CODE_INVALID_INPUT;
    }

    // Memory management and return
    free(dataPoints);
    return returnCode;
}

/**
 * Process input string and return count of valid characters
 *
 * @param inputString The string to process
 * @param maxLength Maximum length to process
 * @return Count of valid characters
 */
int processInput(const char *inputString, int maxLength) {
    int count = 0;

    // Input validation
    if (!inputString || maxLength <= 0) {
        return -1;
    }

    // Process each character with a proper for loop
    for (int i = 0; i < maxLength && inputString[i] != '\0'; i++) {
        char currentChar = inputString[i];

        // Switch statement formatting
        switch (currentChar) {
            case 'a':
            case 'e':
            case 'i':
            case 'o':
            case 'u':
                // Found a vowel
                count++;
                break;
            case '0':
            case '1':
            case '2':
                // Numbers 0-2 are counted
                count++;
                break;
            default:
                // Other characters ignored
                break;
        }
    }

    return count;
}

/**
 * Create a formatted output string based on input
 *
 * @param input The input string
 * @param count The count value to include
 * @return Newly allocated formatted string (caller must free)
 */
char *createFormattedOutput(const char *input, int count) {
    // Validate input
    if (!input) {
        return NULL;
    }

    // Allocate memory for output string
    size_t outputLength = strlen(input) + 50; // Extra space for formatting
    char *result = (char *)malloc(outputLength);

    if (!result) {
        return NULL;
    }

    // Create formatted output
    snprintf(result, outputLength, "Input [%s] has %d special characters",
             input, count);

    return result;
}
