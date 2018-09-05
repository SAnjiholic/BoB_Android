#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>

void my_search_dir(DIR *search_dir, int level, char *root_dir);

void ret_listd(char *dir_name, char *now_dir, int level){
	DIR *deep_dir;
	char *real_dir;
	real_dir = (char *) malloc(strlen(dir_name)+strlen(now_dir)+0x10);
	sprintf(real_dir,"%s/%s",now_dir,dir_name);
	deep_dir = opendir(real_dir);
	my_search_dir(deep_dir, level, real_dir);
	free(real_dir);
}

void my_search_dir(DIR *search_dir, int level, char *root_dir){
	char *_level = "  =>";
	char *n_name;
	struct dirent *dnt;
	struct stat st;
	if(search_dir != NULL){
		while( (dnt = readdir(search_dir)) != NULL){
			n_name = (char *) malloc(strlen(root_dir)+strlen(dnt->d_name)+0x10);
			sprintf(n_name,"%s/%s",root_dir,dnt->d_name);
			lstat(n_name,&st);
			if(S_ISDIR(st.st_mode)){
				if(strcmp(dnt->d_name,".") && strcmp(dnt->d_name,"..")){
					//printf("%s/%s : dir\n",root_dir,dnt->d_name);
					level++;
					ret_listd(dnt->d_name,root_dir,level);
				}
			}
			else{
				printf("%s : file \n",n_name);
			}
			free(n_name);
		}
	}
}

int main(int argc, char *argv[]){
	DIR *dir;
	int level = 0;
	struct dirent *ent;
	char *root_dir = ""; // input search dir 
	dir = opendir (root_dir);
	if (dir != NULL){
		my_search_dir(dir, level, root_dir);
	}
	else {
		perror ("");
		return EXIT_FAILURE;
	}
	closedir (dir);
}

