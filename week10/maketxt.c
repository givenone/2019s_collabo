#include<stdio.h>
union a{
	int x;
	float y;
};

int main(){
	FILE *fp = fopen("input_1234.txt", "w");

	for(int i=0; i<16; i++){
		union a temp = {.y = 1.0};
		fprintf(fp, "%x\n", temp.x);
		printf("%x\n", temp.x);
	}
	for(int k=1; k<=4; k++)
	{
		union a temp = {.y = (float)k};
		fprintf(fp, "%x\n", temp.x);
		printf("%x\n", temp.x);
		for(int i=1 ; i<16 ; i++){
			union a temp = {.y = 2.0};
			fprintf(fp, "%x\n", temp.x);
			printf("%x\n", temp.x);
		}
	}


	fclose(fp);
}
