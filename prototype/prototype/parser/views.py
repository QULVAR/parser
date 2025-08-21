from django.shortcuts import render
from django.http import JsonResponse
from django.conf import settings
from datetime import datetime as dt
from rapidfuzz import process, fuzz
import unicodedata
import pandas as pd
import os

def get_dict_from_file():
    file_path = os.path.join(settings.BASE_DIR, 'parser', 'static', 'files', 'output.xlsx')
    df = pd.read_excel(file_path, header=None)

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
    return categories
    
    
def get_goods(request, flag = True):
    dict_from_file = get_dict_from_file()
    keys = list(dict_from_file.keys())
    l = 0
    result = {'data': []}
    for i in keys:
        result['data'].append({})
        result['data'][-1]['category'] = i
        result['data'][-1]['items'] = []
        keys_items = list(dict_from_file[i].keys())
        for j in keys_items:
            result['data'][-1]['items'].append({})
            result['data'][-1]['items'][-1]['item'] = j
            l = max(l, len(j))
            result['data'][-1]['items'][-1]['price'] = dict_from_file[i][j]
    result['len'] = l
    if flag:
        return JsonResponse(result)
    else:
        return result
    

def normalize(s: str) -> str:
    s = unicodedata.normalize('NFKD', s)
    s = ''.join(ch for ch in s if not unicodedata.combining(ch))
    return s.casefold().strip()
    
    
def get_catalog():
    dict_file = get_dict_from_file()
    dict_keys = list(dict_file.keys())
    catalog = [i + ' (category)' for i in dict_keys]
    for i in dict_keys:
        catalog.extend(list(dict_file[i].keys()))
    return catalog


def search(query: str, score_cutoff: int = 65):
    q = normalize(query)
    results = process.extract(
        q,
        get_catalog(),
        scorer=fuzz.token_set_ratio,
        processor=normalize,
        score_cutoff=score_cutoff,
        limit=None
    )
    data = get_goods(None, False)['data']
    results = [m for m, _, _ in results]
    for i in range(0, len(data)):
        if not data[i]['category'] + ' (category)' in results:
            j = 0
            while j < len(data[i]['items']):
                if not data[i]['items'][j]['item'] in results:
                    del data[i]['items'][j]
                else:
                    j += 1
    i = 0
    while i < len(data):
        if data[i]['items'] == []:
            del data[i]
        else:
            i += 1
    return data


def get_by_search(request):
    query = request.GET.get('query', '')
    return JsonResponse({'data': search(query)})
    


def get_sum(request):
    date_str = '02-07-2025'
    date_str2 = '15-07-2025'
    date_obj = dt.strptime(date_str, '%d-%m-%Y')
    weekday = date_obj.weekday()
    date_obj2 = dt.strptime(date_str2, '%d-%m-%Y')
    weekday2 = date_obj2.weekday()
    diff_in_days = (date_obj2 - date_obj).days
    result = 0
    categories = get_dict_from_file()
    categories_choice = [
        ['Карты памяти CF', 'Карта памяти SanDisk Extreme CF 64 Gb, 120 Mb/s'],
        ['Жилеты', 'Easyrig Minimax'],
        ['Экшн камеры и 360 ', 'DJI Osmo Pocket 3'],
        ['Фрост рамы', 'Пена 100х100 см серебро/белая']
    ]
    while diff_in_days != 0:
        if diff_in_days >= 7:
            diff_in_days -= 7
            for choice in categories_choice:
                result += categories[choice[0]][choice[1]][1]
        else:
            if weekday > weekday2:
                if weekday == 4:
                    for choice in categories_choice:
                        result += categories[choice[0]][choice[1]][0]
                    weekday = 1
                    diff_in_days -= 4
                elif weekday == 5:
                    for choice in categories_choice:
                        result += categories[choice[0]][choice[1]][0]
                    weekday = 1
                    diff_in_days -= 3
                elif weekday < 4:
                    for choice in categories_choice:
                        result += categories[choice[0]][choice[1]][0]
                    weekday += 1
                    diff_in_days -= 1
                else:
                    raise ValueError
            else:
                for choice in categories_choice:
                    result += categories[choice[0]][choice[1]][0] * diff_in_days
                diff_in_days = 0
    return JsonResponse({'result': result})
    
