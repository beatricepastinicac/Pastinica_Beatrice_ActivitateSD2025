#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

struct Node {
	int data;
	struct Node* next;
};

struct Node* head;

void Insert(int x) {
	struct Node* aux = (struct Node*)malloc(sizeof(struct Node));
	aux->data = x;
	aux->next = head;
	head = aux;
	
}
void Print() {
	struct Node* aux = head;
	printf("Lista este: \n");
	while (aux != NULL) {
		printf("%d", aux->data);
		aux = aux->next;
	}
	printf("\n");
}

int main() {

	head = NULL;
	printf("Cate numere?\n");
	int n, i, x;
	scanf("%d", &n);
	for (i = 0; i < n; i++) {
		printf("Introduceti numarul %d: \n");
		scanf("%d", &x);
		Insert(x);
		Print();
	}

	return 0;
}
