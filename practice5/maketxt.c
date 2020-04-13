#include<stdio.h>

int main(){
	FILE *fp = fopen("input.txt", "wb");

	for(int i=0; i<8192; i++){
		fwrite(&i, sizeof(int), 1, fp);
	}

	fclose(fp);

	FILE *fc = fopen("input.txt", "rb");
	
	int num;
	for(int i=0; i<8192; i++){
		fread(&num, sizeof(int), 1, fc);
		printf("%d ",num);
	}
	return 0;
}
