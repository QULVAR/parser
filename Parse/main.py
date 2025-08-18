import pandas as pd

# Открываем Excel-файл
df = pd.read_excel("output.xlsx", header=None)  # header=None — не считать первую строку за заголовки


def clean_repeats(row):
    cleaned = []
    last = None
    for val in row:
        if not pd.isna(val):
            cleaned.append(val)
            last = val
    return cleaned

cleaned = []

for row in df.itertuples(index=False):
    cleaned.append(clean_repeats(list(row)))

categories = {}
category = ''
last_added = ''
cleaned = cleaned[5:]
for i in cleaned:
    if len(i) > 0:
        if i[0] != 'Наименование товара':
            if len(i) == 1:
                if 'при аренде' in i[0]:
                    categories[category][last_added].append(i[0])
                elif i[0] != '(Цена за 24 часа)':
                    if not i[0] in categories.keys():
                        categories[i[0]] = {}
                    category = i[0]
            else:
                categories[category][i[0]] = i[1:]
                last_added = i[0]

keys = list(categories.keys())
for i in keys:
    if categories[i] == {}:
        del categories[i]

print('{')
for i in categories.keys():
    print('    ' + i + ': {')
    for j in categories[i].keys():
        print('        ' + j + ': ' + str(categories[i][j]) + ',')
    print('    },')
print('}\n\n\n\n\n')

from random import randint as rnd

keys = list(categories.keys())

for _ in range(4):
    key = keys[rnd(0, len(keys) - 1)]
    keys2 = list(categories[key].keys())
    key2 = keys2[rnd(0, len(keys2) - 1)]
    print(f'{key}: {key2} {categories[key][key2]}\n')

categories_choice = [
    ['Карты памяти CF', 'Карта памяти SanDisk Extreme CF 64 Gb, 120 Mb/s'],
    ['Жилеты', 'Easyrig Minimax'],
    ['Экшн камеры и 360 ', 'DJI Osmo Pocket 3'],
    ['Фрост рамы', 'Пена 100х100 см серебро/белая']
]

for i in categories_choice:
    print(i[0], i[1], categories[i[0]][i[1]])