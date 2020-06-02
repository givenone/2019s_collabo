#include<stdio.h>
union a{
	int x;
	float y;
};

int main(){
	FILE *fp = fopen("input_64.txt", "w");

	for(int i=0; i<64; i++){
		union a temp = {.y = 1.0};
		fprintf(fp, "%x\n", temp.x);
		printf("%x\n", temp.x);
	}
	for(int k=1; k<= 64; k++)
	{
		union a temp = {.y = (float)k};
		fprintf(fp, "%x\n", temp.x);
		printf("%x\n", temp.x);
		for(int i=1 ; i<64 ; i++){
			union a temp = {.y = 1.0};
			fprintf(fp, "%x\n", temp.x);
			printf("%x\n", temp.x);
		}
	}


	fclose(fp);
}
