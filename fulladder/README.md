## Моделирование цифровых схем в программе "Logisim" на примере полного сумматора (Full Adder) двух 3-битных входов

### Инструменты
Моделирование будет происходить в программе с открытым исходным 
кодом «Logisim» под лицензией GNU GPL 2.0.

Инструкцию по установке можно найти на [официальном сайте](http://www.cburch.com/logisim/download.html).

### Описание 
Назначение схемы состоит в сложении n-битовых входов,
представляющий два числа разрядности n, где n=3 в нашем случае.
Принцип работы заключается в объединении full-adder’ов, которые
применимы для сложения однобитовых входов в схему, способную сложить
входные числа большей разрядности. Full-adder для сложения
однобитовых чисел получается из простейшего half-adder’a добавлением
учёта carry-бита. Ниже приведены схемы для half-adder и full-adder для
n=1

<img src="https://github.com/RustamSubkhankulov/digital-electronics/blob/main/fulladder/pics/adders.png" alt="adders" width="500"/>

### Схема
A[2:0],B[2:0] - входные 3-х битовые числа
С0, С1, С2 - carry-биты, получаемые в результате промежуточных
вычислений
S[2:0] и C - результат сложения - 3-х битовое число и carry-бит
При сложении нулевых битов мы пользуемся простым half-adder, так
как нет значения carry-бита, которые могло бы быть высчитано на
предыдущем шаге и которое должно было бы быть учтено. Сумма
вычисляется при помощи XOR-gate, а carry - с помощью AND-gate.

<img src="https://github.com/RustamSubkhankulov/digital-electronics/blob/main/fulladder/pics/scheme.png" alt="scheme" width="500"/>

При сложении первый и вторых битов мы пользуемся более сложной
схемой. Сначала мы повторяем действия предыдущего шага - используем
XOR и AND gate, чтобы посчитать первые значения суммы и carry. Далее
мы используем еще один half-adder, чтобы сложить carry от предыдущего
бита с получившейся суммой и получаем окончательное значение суммы.
Результирующий сarry же вычисляется с помощью OR-gate от значений
сarry-битов от обоих half-adder’ов.

### Тестирование
Рассмотрим работу схемы на различных входных значениях.

- Все входные биты равны нулю:

<img src="https://github.com/RustamSubkhankulov/digital-electronics/blob/main/fulladder/pics/test1.png" alt="test1" width="500"/>

- Все входные биты равны единице:

<img src="https://github.com/RustamSubkhankulov/digital-electronics/blob/main/fulladder/pics/test2.png" alt="test2" width="500"/>

- 3 + 3 = 6:

<img src="https://github.com/RustamSubkhankulov/digital-electronics/blob/main/fulladder/pics/test3.png" alt="test3" width="500"/>

- 6 + 1 = 7:

<img src="https://github.com/RustamSubkhankulov/digital-electronics/blob/main/fulladder/pics/test4.png" alt="test4" width="500"/>

### Просчёт критического пути

Критический путь выделен на схеме ниже красным цветом:

<img src="https://github.com/RustamSubkhankulov/digital-electronics/blob/main/fulladder/pics/crit.png" alt="crit" width="500"/>

### Примерное число транзисторов:
5 на XOR-gate, 5 на AND-gate, 2 на OR-gate
AND = NAND + NOT
OR = NOR + NOT
XOR = 2xNOT + 2xAND + OR = 5xNOT +2xNAND + NOR
Получаем: 25xNOT + 10xNAND + 5xNOR + 5xNOT + 5xNAND +
2xNOT + 2xNOR = 32xNOT + 15xNAND + 7xNOR
- NOT-gate: 2 транзистора
- NAND-gate: 4 транзистора
- NOR-gate: 4 транзистора
64 + 60 + 28 = 152 транзистора на схему.
