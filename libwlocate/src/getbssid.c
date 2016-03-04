#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>

/* The following is the size of a buffer to contain any error messages
   encountered when the regular expression is compiled. */

#define MAX_ERROR_MSG 0x1000


char* substr (const char* string, int pos, int len, const char* replace)
{
    char* substring;
    int   i;
    int   length;
 
    if (string == NULL)
        return NULL;
    length = strlen(string);
    if (pos < 0) {
        pos = length + pos;
        if (pos < 0) pos = 0;
    }
    else if (pos > length) pos = length;
    if (len <= 0) {
        len = length - pos + len;
        if (len < 0) len = length - pos;
    }
    if (pos + len > length) len = length - pos;
    if (replace != NULL) {
        if ((substring = malloc(sizeof(*substring)*(length-len+strlen(replace)+1))) == NULL)
            return NULL;
        for (i = 0; i != pos; i++) substring[i] = string[i];
        pos = pos + len;
        for (len = 0; replace[len]; i++, len++) substring[i] = replace[len];
        for (; string[pos]; pos++, i++) substring[i] = string[pos];
        substring[i] = '\0';
    }
    else {
        if ((substring = malloc(sizeof(*substring)*(len+1))) == NULL)
            return NULL;
        len += pos;
        for (i = 0; pos != len; i++, pos++)
            substring[i] = string[pos];
        substring[i] = '\0';
    }
 
    return substring;
}


/* Compile the regular expression described by "regex_text" into
   "r". */

static int compile_regex (regex_t * r, const char * regex_text)
{
    int status = regcomp (r, regex_text, REG_EXTENDED|REG_NEWLINE);
    if (status != 0) {
	char error_message[MAX_ERROR_MSG];
	regerror (status, r, error_message, MAX_ERROR_MSG);
        printf ("Regex error compiling '%s': %s\n",
                 regex_text, error_message);
        return 1;
    }
    return 0;
}

/*
  Match the string in "to_match" against the compiled regular
  expression in "r".
 */

static const char * match_regex (regex_t * r, const char * to_match)
{
    /* "P" is a pointer into the string which points to the end of the
       previous match. */
    const char * p = to_match;
    char * dest;
    /* "N_matches" is the maximum number of matches allowed. */
    const int n_matches = 10;
    /* "M" contains the matches found. */
    regmatch_t m[n_matches];

    while (1) {
        int i = 0;
        int nomatch = regexec (r, p, n_matches, m, 0);
        if (nomatch) {
            printf ("No more matches.\n");
            return "";
        }
        for (i = 0; i < n_matches; i++) {
            int start;
            int finish;
            if (m[i].rm_so == -1) {
                break;
            }
            start = m[i].rm_so + (p - to_match);
            finish = m[i].rm_eo + (p - to_match);
            if (i == 0) {
                //printf ("$& is ");
				//printf ("'%.*s' (bytes %d:%d)\n", (finish - start), to_match + start, start, finish);
            }
            else {
                //printf ("$%d is ", i);
				//printf ("'%.*s' (bytes %d:%d)\n", (finish - start), to_match + start, start, finish);
				return substr(to_match, start, (finish - start), NULL);
            }
            
			
        }
        p += m[0].rm_eo;
    }
    return "";
}

int * getMeshBssid (){
    static int bssid[8];

    regex_t r;
    const char * regex_text;
    const char * result;
    regex_text = ".*option bssid '(.*)'.*";

    FILE *f = fopen("/etc/config/wireless", "rb");
    fseek(f, 0, SEEK_END);
    long fsize = ftell(f);
    fseek(f, 0, SEEK_SET);

    char *string = malloc(fsize + 1);
    fread(string, fsize, 1, f);
    fclose(f);

    string[fsize] = 0;

    compile_regex(& r, regex_text);
    result = match_regex(& r, string);
    regfree (& r);

    char * str = strdup(result);

    char* tok;
    tok = strtok(str, ":");

    int number = (int)strtol(tok, NULL, 16);
    bssid[0] = number;
    for(int i = 1 ; i < 6 ; i++){
        tok = strtok(NULL, ":");
        int number = (int)strtol(tok, NULL, 16);
        bssid[i] = number;
    }

    return bssid;
}
