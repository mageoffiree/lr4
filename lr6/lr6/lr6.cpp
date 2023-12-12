#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <windows.h>
#include <unordered_map>


using namespace std;

int* mass(int n) // Выделение памяти на массив
{
	int* Mass = new int[n];
	return Mass; 
}

int* feal_array(int n, int* mass) // Заполнение массива случайными числами
{
	for (int i = 0; i < n; i++)
		mass[i] = rand(); // Запись случайного числа, которое вернет rand()
	return mass;
}

int* sort_array(int n, int* mass) // Сортировка массива
{
	for (int i = 1; i < n; i++)
		for (int j = i; j > 0 && mass[j - 1] > mass[j]; j--) // Пока j>0 и элемент j-1 > j
			swap(mass[j - 1], mass[j]);        // Меняем местами элементы j и j-1
	return mass;
}

void print_array(int n, int* mass) // Вывод массива на экран
{
	cout << endl;
	for (int i = 0; i < n; i++)
		cout << mass[i] << endl;
	cout << endl;
}

void del_array(int* mass) // Очистка памяти для массива
{
	delete[] mass;
}

//----------------------------------------------------

struct Node { // Структура узла 
	int val;
	Node* next;

	Node(int _val) : val(_val), next(nullptr) {}
};

struct listt { // Структура списка
	Node* first;
	Node* last;

	listt() : first(nullptr), last(nullptr) {}

	bool is_empty() { // Проверка на пустоту
		return first == nullptr;
	}

	void push_back(int _val) { // Добавление элемента в конец списка
		Node* p = new Node(_val);
		if (is_empty()) {
			first = p;
			last = p;
			return;
		}
		last->next = p;
		last = p;
	}

	void print() { // Вывод спискана на экран
		if (is_empty()) return;
		Node* p = first;
		while (p) {
			cout << p->val << " ";
			p = p->next;
		}
		cout << endl;
	}

	Node* operator[] (const int index) { // Обращение к узлу по индексу
		if (is_empty()) return nullptr;
		Node* p = first;
		for (int i = 0; i < index; i++) {
			p = p->next;
			if (!p) return nullptr;
		}
		return p;
	}
};

void sort_listt(int n, listt l) { // Сортировка списка по средствам массива
	int* array = mass(n);
	for (int i = 0; i < n; i++) // Перенос данных из списка в массив
		array[i] = l[i]->val;
	sort_array(n, array); // Сортировка массива
	for (int i = 0; i < n; i++) // Занесение отсортированных данных обратно в список
		l[i]->val = array[i];
	del_array;// Очистка памяти на массив
}

//---------------------------------------------
/*void print_hashmap(unordered_map<int, int> ar) { // Вывод хеш таблицы на экран
	cout << "---------------" << endl;
	for (auto& item : ar) 
		cout << item.first << " " << item.second << endl;
	cout << "---------------" << endl;
} */

/*unordered_map<int, int> feel_hashmap(int n, unordered_map<int, int> ar) {
	for (int i = 0; i < n; i++)// Заполнение хеш таблицы случайными числами
		ar[i] = rand();
	return ar;
}*/

/*unordered_map<int, int> sort_hasmap(int n, unordered_map<int, int> ar) {
	int* array = mass(n);
	for (auto& item : ar) //запись данных из хеш таблицы в массив 
		array[item.first - 1] = item.second;
	sort_array(n, array); //сортировка массива
	for (auto& item : ar)  //запись данных из массива в хеш таблицу
		item.second = array[item.first - 1];
	del_array;//очистка памяти на массив
	return ar;
}*/

int main()
{
	SetConsoleCP(1251);
	SetConsoleOutputCP(1251);
	srand(time(NULL));

	int z = 1;
	while (z == 1) {

		std::cout << endl << "Введи кол-во элементов:" << endl;
		int size;
		std::cin >> size;
		std::cout << endl;

		int q = 1;
		while (q == 1) {

			std::cout << "Выберите с какой структурой данных вы хотите работать:" << endl;
			std::cout << "1 - Работа с массивом (ArrayList);" << endl;
			std::cout << "2 - Работа со связным списком (LinkedList);" << endl;
			std::cout << "3 - Работа с хеш таблицей (HashMap);" << endl << endl;
			int x;
			std::cin >> x;

			switch (x)
			{
			case 1: {
				std::cout << endl << "Вы хотите работать с массивом." << endl << "Что ж, приступим." << endl;

				int* array = mass(size);  // Нужно здесь сохранить значения массива из функции mass(n)
				feal_array(size, array); // Заполняем массив рандомными значениями
				/* std::cout << "Неотсортированный массив:" << endl;
				print_array(size, array);// Вывод массива   */
				clock_t start, end;
				start = clock(); // Начало отсчета времени
				sort_array(size, array);// Сортировка массива
				end = clock(); //Конец отсчета времени
				/* std::cout << "Отсортированный массив:" << endl;
				//print_array(size, array);// Вывод отсортированного массива   */
				printf("Сортировка завершилась за % .4f секунд.\n", ((double)end - start) / ((double)CLOCKS_PER_SEC));
				del_array;// Очистка памяти на массив
				break;
			}
			case 2: {
				std::cout << endl << "Вы хотите работать со связным списком." << endl << "Что , приступим." << endl;

				listt l;
				for (int i = 0; i < size; i++) // Запись случайного числа в список, которое вернет rand()
					l.push_back(rand());
				/* std::cout << "Неотсортированный список:" << endl;
				l.print(); // Вывод списка     */
				clock_t start, end;
				start = clock(); // Начало отсчета времени
				sort_listt(size, l);
				end = clock(); // Конец отсчета времени
				/* std::cout << "Отсортированный список:" << endl;
				l.print(); // Вывод отсортированного списка       */
				printf("Сортировка завершилась за % .4f секунд.\n", ((double)end - start) / ((double)CLOCKS_PER_SEC));
				break;
			}
			case 3: {
				std::cout << endl << "Вы хотите работать с хеш таблицей." << endl << "Что , приступим." << endl;

				unordered_map<int, int> ar;

				for (int i = 1; i < size + 1; i++)//feel_hashmap(size, ar);  // Заполнение хеш таблицы случайными числами
					ar[i] = rand();

				/*std::cout << "Неотсортированная хеш таблица:" << endl;
				std::cout << "---------------" << endl; //print_hashmap(ar); // Вывод хеш таблицы
				for (auto& item : ar)
					cout << item.first << " " << item.second << endl;
				std::cout << "---------------" << endl;*/

				clock_t start, end;
				start = clock(); // Начало отсчета времени

				int* array = mass(size); //sort_hasmap(size, ar);
				for (auto& item : ar) // Запись данных из хеш таблицы в массив 
					array[item.first - 1] = item.second;
				sort_array(size, array); // Сортировка массива
				for (auto& item : ar)  // Запись данных из массива в хеш таблицу
					item.second = array[item.first - 1];
				del_array;// Очистка памяти на массив

				end = clock(); // Конец отсчета времени

				/*std::cout << "Отсортированная хеш таблица:" << endl;
				std::cout << "---------------" << endl;  //print_hashmap(ar); // Вывод отсортированной хеш таблицы
				for (auto& item : ar)
					cout << item.first << " " << item.second << endl;
				std::cout << "---------------" << endl;*/

				printf("Сортировка завершилась за % .4f секунд.\n", ((double)end - start) / ((double)CLOCKS_PER_SEC));

				break;
			}
			default: {
				std::cout << endl << "Вы ввели что-то не то :)" << endl;
				break;
			}
			}
			std::cout << endl;
			std::cout << "Если хотите выбрать другую структуру данных введите 1.";
			std::cout << endl;
			std::cin >> q;
			std::cout << endl;
		}
		std::cout << endl;
		std::cout << "Если хотите выбрать другое кол-во элементов введите 1.";
		std::cout << endl;
		std::cin >> z;
		std::cout << endl;
	}
	system("pause");
	return 0;
}