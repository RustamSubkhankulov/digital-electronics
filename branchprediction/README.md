## Исследование работы предсказателя переходов в симуляторе «RISC-V Assembler and Runtime Simulator (RARS)»

В данной работе предлагалось на практике познакомиться с работой предсказателя переходов в симуляторе RISC-V архитектуры и проанализировать его поведение. 

### Инструменты
Запуск симуляции программ на ассемблере RISC-V будет происходить в программе с открытым исходным кодом [«RISC-V Assembler and Runtime Simulator (RARS)»](https://www.opensourceagenda.com/projects/rars) под лицензией MIT.

Скачать симулятор можно на официальной странице [Github](https://github.com/TheThirdOne/rars/releases/tag/v1.6).

### Анализ работы BHT

#### Пункт №1

<img src="https://github.com/RustamSubkhankulov/digital-electronics/blob/main/branchprediction/pics/src1.png" alt="src1" width="400"/>

Запустим симуляцию программы В RARS Tool с включенным BHT Simulator c опциями:
- Number of BHT entries == 8
- BHT History size == 1
- Initial value == TAKE

Ниже приведено начальное состояние **BHT** с данными опциями.

<img src="https://github.com/RustamSubkhankulov/digital-electronics/blob/main/branchprediction/pics/bht1i.png" alt="bht1i" width="700"/>

Модель предсказаний, используемая **BHT** с данными настройками, описывается следующим конечным автоматом состояний:

<img src="https://github.com/RustamSubkhankulov/digital-electronics/blob/main/branchprediction/pics/dfa1.png" alt="dfa1" width="600"/>

Состояние BHT в конце симуляции:

<img src="https://github.com/RustamSubkhankulov/digital-electronics/blob/main/branchprediction/pics/bht1f.png" alt="bht1f" width="700"/>

- Инструкции перехода **magic_br_1** соответствует *Index*=5, точность предсказания - 99.99 (начальное предположение неверно, branch не взят, *Prediction* -> NOT TAKE, на всех последующих итерациях предположение верно).
- Инструкции перехода **magic_br_2** соответствует *Index*=7, точность предсказания - 100 (начальное предположение верно, branch взят, *Prediction* сохраняет значение TAKE, на всех последующих итерациях предположение верно).

#### Пункт №2

Добавим в ассемблерный код инструкции nop так, чтобы точность предсказания для обоих инструкций прямого условного перехода **magic_br_1** и **magic_br_2** составила 0.

<img src="https://github.com/RustamSubkhankulov/digital-electronics/blob/main/branchprediction/pics/src2.png" alt="src2" width="400"/>

Для этого вставим 6 инструкций nop между **magic_br_1** и **magic_br_2**. Таким образом, обе инструкции перехода будут сопоставлены одной и той же записи в **BHT** - с значением *Index* == 5. 

-На первой итерации предположение TAKE неверно для **magic_br_1**, *Prediction* -> NOT TAKE.
-Далее предположение NOT_TAKE в записи, которая теперь ставится в соотвествии уже **magic_br_2**, также неверно, и *Prediction* -> TAKE
-Таким образом на каждой следующей итерации *Prediction* для **magic_br_1** - TAKE, а для **magic_br_2** - NOT TAKE. 

Как результат, точность предсказаний для обеих инструкций перехода - 0

<img src="https://github.com/RustamSubkhankulov/digital-electronics/blob/main/branchprediction/pics/bht2f.png" alt="bht2f" width="700"/>

#### Пункт №3

Запустим симуляцию модифицированной программы из пункта 2 используя новые настройки **BHT**:
- Number of BHT entries == 8
- BHT History size == 2
- Initial value == TAKE

Ниже приведено начальное состояние **BHT** с данными опциями.

<img src="https://github.com/RustamSubkhankulov/digital-electronics/blob/main/branchprediction/pics/bht3i.png" alt="bht3i" width="700"/>

Модель предсказаний, используемая **BHT** с данными настройками, описывается следующим конечным автоматом состояний:

<img src="https://github.com/RustamSubkhankulov/digital-electronics/blob/main/branchprediction/pics/dfa2.png" alt="dfa2" width="600"/>

Состояние **BHT** в конце симуляции:

<img src="https://github.com/RustamSubkhankulov/digital-electronics/blob/main/branchprediction/pics/bht3f.png" alt="bht3f" width="700"/>

- Как и в предыдущей симуляции, обеим инструкциям перехода соответствует одна и та же запись в **BHT** - *Index* == 5.
- Начальное состояние записи - *Prediction* = TAKE, *History* = T,T
- Первая итерация, **magic_br_1**: *Prediction* = TAKE, предсказание неверное, *Prediction* -> TAKE, *History* -> T, NT
- Первая итерация, **magic_br_2**: *Prediction* = NOT TAKE, предсказание верное,  *Prediction* -> TAKE, *History* -> NT, T

- На последующих итерациях для **magic_br_1** Prediction всегда будет иметь значение TAKE, *History* - NT, T, предположение будет неверным, после инструкции *Prediction* будет оставаться в значении TAKE, а *History* сменяться на T, NT. 
- Тогда для **magic_br_2** *Prediction* всегда будет иметь значение TAKE, *History* - T, NT, предположение будет верным, после инструкции *Prediction* будет оставаться в значении TAKE, а *History* сменяться на NT, T. Далее на каждой итерации ситуация повторяется.

Таким образом точность предсказания для **magic_br_1** - 0, а для **magic_br_2** - 100.

#### Пункт №4

Дополним код программы из пункта 2, добавив две инструкции **beq** так, чтобы точность предсказаний для всех 4 инструкций прямого условного перехода (**magic_br_1**, **magic_br_2** + 2 новых инструкции) не превышала 0.0001. Инструкции **beq** и **nop** расположены так, чтобы для всех четырех инструкций перехода использовалась одна и та же запись в **BHT** с *Index* == 5.

<img src="https://github.com/RustamSubkhankulov/digital-electronics/blob/main/branchprediction/pics/src3.png" alt="src3" width="400"/>

Первая итерация: 
- **magic_br_1**: переход не выполнен, *Prediction*: TAKE -> TAKE, *History*: T,T ->  T, NT
- **magic_br_2**: переход выполнен, *Prediction*: TAKE -> TAKE, *History*: T, NT ->  NT, T
- **magic_br_3**: переход выполнен, *Prediction*: TAKE -> TAKE, *History*: NT, T ->  T, T
- **magic_br_4**: переход не выполнен, *Prediction*: TAKE -> TAKE, *History*:   T, T ->  T, NT
К концу первой итерации предсказания для **magic_br_1** и **magic_br_4** неверные, для **magic_br_2** и **magic_br_3** - верные

Последующие итерации:
- **magic_br_1**: переход не выполнен, *Prediction*: TAKE -> NOT TAKE, *History*: T,NT ->  NT, NT
- **magic_br_2**: переход выполнен, *Prediction*: NOT TAKE -> NOT TAKE, *History*: NT, NT ->  NT, T
- **magic_br_3**: переход выполнен, *Prediction*: NOT TAKE -> TAKE, *History*: NT, T ->  T, T
- **magic_br_4**: переход не выполнен, *Prediction*: TAKE -> TAKE, *History*:   T, T ->  T, NT
На каждой итерации предсказания для всех инструкций перехода оказываются неверными.

<img src="https://github.com/RustamSubkhankulov/digital-electronics/blob/main/branchprediction/pics/bht4.png" alt="bht4" width="500"/>

Таким образом, точность для переходов: 
- **magic_br_1**: 0 / 10000 = 0
- **magic_br_2**: 1 / 10000 = 0.0001
- **magic_br_3**: 1 / 10000 = 0.0001
- **magic_br_4**: 0 / 10000 = 0
