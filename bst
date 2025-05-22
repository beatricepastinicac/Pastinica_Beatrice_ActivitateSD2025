#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Structura Farmacie
typedef struct {
	char* denumireFarmacie;
	int idFarmacie;
	float cifraAfaceri;
	char* numeFarmacist;
	char* localitate;
	int nrAngajati;
} Farmacie;

// Nod pentru arbore BST
typedef struct Nod {
	Farmacie info;
	struct Nod* stg;
	struct Nod* dr;
} Nod;

// Nod pentru lista simpla
typedef struct NodLS {
	int id;
	struct NodLS* next;
} NodLS;

// Functii BST
Nod* creareNod(Farmacie f) {
	Nod* nou = (Nod*)malloc(sizeof(Nod));
	nou->info.idFarmacie = f.idFarmacie;
	nou->info.nrAngajati = f.nrAngajati;
	nou->info.cifraAfaceri = f.cifraAfaceri;
	nou->info.denumireFarmacie = (char*)malloc(strlen(f.denumireFarmacie) + 1);
	strcpy(nou->info.denumireFarmacie, f.denumireFarmacie);
	nou->info.numeFarmacist = (char*)malloc(strlen(f.numeFarmacist) + 1);
	strcpy(nou->info.numeFarmacist, f.numeFarmacist);
	nou->info.localitate = (char*)malloc(strlen(f.localitate) + 1);
	strcpy(nou->info.localitate, f.localitate);
	nou->stg = nou->dr = NULL;
	return nou;
}

Nod* inserareBST(Nod* rad, Farmacie f) {
	if (rad == NULL) return creareNod(f);
	if (f.idFarmacie < rad->info.idFarmacie)
		rad->stg = inserareBST(rad->stg, f);
	else
		rad->dr = inserareBST(rad->dr, f);
	return rad;
}

void traversareInordine(Nod* rad) {
	if (rad) {
		traversareInordine(rad->stg);
		printf("ID: %d | Denumire: %s | Localitate: %s | Angajati: %d | CA: %.2f | Sef: %s\n",
			rad->info.idFarmacie, rad->info.denumireFarmacie, rad->info.localitate,
			rad->info.nrAngajati, rad->info.cifraAfaceri, rad->info.numeFarmacist);
		traversareInordine(rad->dr);
	}
}

void angajatiLocalitate(Nod* rad, const char* localitate, int* total) {
	if (rad) {
		if (strcmp(rad->info.localitate, localitate) == 0)
			*total += rad->info.nrAngajati;
		angajatiLocalitate(rad->stg, localitate, total);
		angajatiLocalitate(rad->dr, localitate, total);
	}
}

float cautaCaDupaId(Nod* rad, int id) {
	if (rad == NULL) return -1;
	if (rad->info.idFarmacie == id)
		return rad->info.cifraAfaceri;
	if (id < rad->info.idFarmacie)
		return cautaCaDupaId(rad->stg, id);
	else
		return cautaCaDupaId(rad->dr, id);
}

Nod* stergeFrunzeNivel(Nod* rad, int nivelCurent, int nivelTarget) {
	if (rad == NULL) return NULL;
	if (nivelCurent == nivelTarget && rad->stg == NULL && rad->dr == NULL) {
		free(rad->info.denumireFarmacie);
		free(rad->info.numeFarmacist);
		free(rad->info.localitate);
		free(rad);
		return NULL;
	}
	rad->stg = stergeFrunzeNivel(rad->stg, nivelCurent + 1, nivelTarget);
	rad->dr = stergeFrunzeNivel(rad->dr, nivelCurent + 1, nivelTarget);
	return rad;
}

// Functii Lista Simpla
void adaugaLista(NodLS** cap, int id) {
	NodLS* nou = (NodLS*)malloc(sizeof(NodLS));
	nou->id = id;
	nou->next = NULL;
	if (*cap == NULL) *cap = nou;
	else {
		NodLS* temp = *cap;
		while (temp->next) temp = temp->next;
		temp->next = nou;
	}
}

void salvareIduriNivel(Nod* rad, NodLS** lista, int nivelCurent, int nivelTarget) {
	if (rad) {
		if (nivelCurent == nivelTarget)
			adaugaLista(lista, rad->info.idFarmacie);
		salvareIduriNivel(rad->stg, lista, nivelCurent + 1, nivelTarget);
		salvareIduriNivel(rad->dr, lista, nivelCurent + 1, nivelTarget);
	}
}

void afisareLista(NodLS* cap) {
	while (cap) {
		printf("ID Farmacie: %d\n", cap->id);
		cap = cap->next;
	}
}

// Dezalocari
void dezalocareArbore(Nod* rad) {
	if (rad) {
		dezalocareArbore(rad->stg);
		dezalocareArbore(rad->dr);
		free(rad->info.denumireFarmacie);
		free(rad->info.numeFarmacist);
		free(rad->info.localitate);
		free(rad);
	}
}

void dezalocareLista(NodLS* cap) {
	while (cap) {
		NodLS* aux = cap;
		cap = cap->next;
		free(aux);
	}
}

int main() {
	Nod* rad = NULL;
	Farmacie f1 = { "Farmacia 1", 100, 50000, "Ionescu", "Bucuresti", 15 };
	Farmacie f2 = { "Farmacia 2", 50, 40000, "Popescu", "Cluj", 10 };
	Farmacie f3 = { "Farmacia 3", 150, 75000, "Georgescu", "Iasi", 20 };
	Farmacie f4 = { "Farmacia 4", 25, 30000, "Marin", "Bucuresti", 8 };
	Farmacie f5 = { "Farmacia 5", 120, 60000, "Dobre", "Cluj", 12 };

	rad = inserareBST(rad, f1);
	rad = inserareBST(rad, f2);
	rad = inserareBST(rad, f3);
	rad = inserareBST(rad, f4);
	rad = inserareBST(rad, f5);

	printf("--- Traversare inordine ---\n");
	traversareInordine(rad);

	int total = 0;
	angajatiLocalitate(rad, "Cluj", &total);
	printf("\nTotal angajati in Cluj: %d\n", total);

	printf("\nCifra afaceri farmacie cu ID 150: %.2f\n", cautaCaDupaId(rad, 150));

	rad = stergeFrunzeNivel(rad, 0, 2);
	printf("\n--- Dupa stergerea frunzelor de pe nivelul 2 ---\n");
	traversareInordine(rad);

	NodLS* lista = NULL;
	salvareIduriNivel(rad, &lista, 0, 1);
	printf("\nID-uri de pe nivelul 1:\n");
	afisareLista(lista);

	dezalocareLista(lista);
	dezalocareArbore(rad);
	return 0;
}
