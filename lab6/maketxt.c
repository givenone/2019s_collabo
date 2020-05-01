#include<stdio.h>
union a{
	int x;
	float y;
};

int main(){
	FILE *fp = fopen("input.txt", "w");

	for(int i=0; i<16; i++){
		union a temp = {.y = 1.0};
		fprintf(fp, "%x\n", temp.x);
	}
	for(int i=0 ; i<16; i++){
		union a temp = {.y = 2.0};
		fprintf(fp, "%x\n", temp.x);
	}

	fclose(fp);
}
