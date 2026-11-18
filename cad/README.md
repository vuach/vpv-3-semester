# CAD — катушки и держатель для Ender-3

Все размеры в миллиметрах. Исходники OpenSCAD хранятся в этой папке; для изготовления используйте их экспорт в STL. Модели являются опытными и должны проверяться на реальных деталях.

## V1 — воздушная катушка

**Файл:** [EDC_Bobbin_V1.scad](EDC_Bobbin_V1.scad)

- Намоточный цилиндр Ø10 мм, окно 4,1 мм.
- Бортики Ø16 мм, нижний 0,8 мм, верхний 1,2 мм.
- Посадочное отверстие Ø6 мм.
- План: 160 витков (8×20), ПЭТВ-2 Ø0,16 мм (в изоляции около Ø0,19 мм).
- Для печати: открыть SCAD, нажать **F6 → File → Export → Export as STL**.

Команда (OpenSCAD CLI):
```bash
openscad -o EDC_Bobbin_V1.stl EDC_Bobbin_V1.scad
```

## Кронштейн Ender-3

**Файл:** [EDC_Ender3_probe_mount_V0.scad](EDC_Ender3_probe_mount_V0.scad)

Основан на реальных замерах двух крепёжных винтов М4 на нестандартном белом корпусе обдува: расстояние между центрами 62,25 мм. Вынос конструкции и зазоры с вентиляторами проверяются непосредственно на принтере.

В Customizer меняется `part`. Примеры экспорта:

```bash
openscad -o Ender3_mount.stl      -D 'part="mount"'      EDC_Ender3_probe_mount_V0.scad
openscad -o Ender3_probe_foot.stl -D 'part="probe_foot"' EDC_Ender3_probe_mount_V0.scad
openscad -o Ender3_spacer_10.stl  -D 'part="spacer_10"'  EDC_Ender3_probe_mount_V0.scad
openscad -o Ender3_spacer_20.stl  -D 'part="spacer_20"'  EDC_Ender3_probe_mount_V0.scad
openscad -o Ender3_spacer_30.stl  -D 'part="spacer_30"'  EDC_Ender3_probe_mount_V0.scad
openscad -o Ender3_gauge.stl      -D 'part="gauge"'      EDC_Ender3_probe_mount_V0.scad
```

В текущей сборке автор использовал **средние проставки**. После установки необходимо проверить механическую жёсткость и безопасное положение Z: датчик выступает ниже сопла.

## V2 — сменная воздушная и ферритовая катушка

**Файл:** [EDC_V2_interchangeable.scad](EDC_V2_interchangeable.scad)

- Цилиндр намотки Ø4,2 мм, высота намотки 3,2 мм.
- План: 75 витков (5×15), провод ПЭТВ-2 Ø0,16 мм.
- Наружный бортик Ø7,5 мм; общая высота корпуса 28 мм.
- Посадочное глухое гнездо Ø6,15 мм, глубиной 7 мм; штифт держателя Ø5,8 мм.
- Отверстие под феррит для основной модели Ø2,35 мм, длиной 15,3 мм: сердечник Ø2 × 15 мм (реальный допуск проверить по факту).
- **V2-Air:** канал остаётся пустым; **V2-Ferrite:** в идентичный корпус вставляется феррит.

Варианты:

```bash
openscad -o V2_universal_2x15.stl -D 'part="universal_2x15"' EDC_V2_interchangeable.scad
openscad -o V2_universal_1p8x10.stl -D 'part="universal_1p8x10"' EDC_V2_interchangeable.scad
openscad -o V2_universal_2p2x10.stl -D 'part="universal_2p2x10"' EDC_V2_interchangeable.scad
openscad -o V2_socket_gauge.stl -D 'part="socket_gauge"' EDC_V2_interchangeable.scad
```

Для сравнения разных сердечников желательно сохранять одинаковые намотку, высоту датчика над образцом и условия возбуждения.

## Текущий статус

По состоянию на 18.11.2026 все запланированные детали **напечатаны**, катушки **намотаны**. Электрические параметры катушек и первая экспериментальная карта ещё не опубликованы.

**Важно:** `.scad` — редактируемые исходники. Эта папка содержит модели, из которых можно повторно построить `.stl`; файлы STL как отдельные бинарные вложения здесь пока не размещены.
