#include<stdio.h>
union a{
	int x;
	float y;
};

int main(){
	FILE *fp = fopen("input_32.txt", "w");

	for(int i=0; i<32; i++){
		union a temp = {.y = 1.0};
		fprintf(fp, "%x\n", temp.x);
		printf("%x\n", temp.x);
	}
	for(int k=1; k<= 32; k++)
	{
		union a temp = {.y = (float)k};
		fprintf(fp, "%x\n", temp.x);
		printf("%x\n", temp.x);
		for(int i=1 ; i<32 ; i++){
			union a temp = {.y = 1.0};
			fprintf(fp, "%x\n", temp.x);
			printf("%x\n", temp.x);
		}
	}


	fclose(fp);
}
