#include<stdio.h>

int main(){
	FILE *fp = fopen("input.txt", "w");

	for(int i=0; i<16; i++){
		fprintf(fp, "%d\n", 1);
	}
	for(int i=0 ; i<16; i++){
		fprintf(fp, "%d\n", 2);
	}

	fclose(fp);
}
