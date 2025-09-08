from django.shortcuts import render
from django.http import JsonResponse
from django.conf import settings
from django.contrib.auth import get_user_model
from django.db import IntegrityError
from datetime import datetime as dt, timedelta
from rapidfuzz import process, fuzz
import unicodedata
import pandas as pd
import os
import json
from copy import deepcopy
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from rest_framework import status
from rest_framework_simplejwt.tokens import RefreshToken


CACHE_DIR = os.path.join(os.path.dirname(__file__), "cache")

def read_raw_parse():
    file_path = os.path.join(CACHE_DIR, "raw.json")
    with open(file_path, "r", encoding="utf-8") as f:
        return json.load(f)

def read_file_goods():
    file_path = os.path.join(CACHE_DIR, "data.json")
    with open(file_path, "r", encoding="utf-8") as f:
        return json.load(f)
    
def read_file_catalog():
    file_path = os.path.join(CACHE_DIR, "search.json")
    with open(file_path, "r", encoding="utf-8") as f:
        return json.load(f)

try:
    RAW_PARSE = read_raw_parse()
except:
    RAW_PARSE = None

try:
    GOODS = read_file_goods()
except:
    GOODS = None

try:
    CATALOG = read_file_catalog()['data']
except:
    CATALOG = None


def write_file(request):
    global RAW_PARSE, GOODS, CATALOG
    try:
        file_path = os.path.join(CACHE_DIR, "raw.json")
        with open(file_path, "w", encoding="utf-8") as f:
            json.dump(get_dict_from_file(), f, ensure_ascii=False, indent=2)
        file_path = os.path.join(CACHE_DIR, "data.json")
        with open(file_path, "w", encoding="utf-8") as f:
            json.dump(get_goods(request, False), f, ensure_ascii=False, indent=2)
        file_path = os.path.join(CACHE_DIR, "search.json")
        with open(file_path, "w", encoding="utf-8") as f:
            json.dump({'data': get_catalog()}, f, ensure_ascii=False, indent=2)
        RAW_PARSE = read_raw_parse()
        GOODS = read_file_goods()
        CATALOG = read_file_catalog()['data']
        return JsonResponse({'result': 'Success'})
    except:
        return JsonResponse({'result': 'Error'})



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


def get_cached_goods(request):
    write_file(request)
    return JsonResponse(GOODS)
    

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


def search(query: str, score_cutoff: int = 80):
    q = normalize(query)
    results = process.extract(
        q,
        CATALOG,
        scorer=fuzz.partial_token_set_ratio,
        processor=normalize,
        score_cutoff=score_cutoff,
        limit=None
    )
    data = deepcopy(GOODS['data'])
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
    


# ====== 👇 ДОБАВИТЬ ВНИЗ parser/views.py 👇 ======

# "кто я" — аналог request.user в шаблоне
@api_view(["GET"])
@permission_classes([IsAuthenticated])
def me(request):
    u = request.user
    return JsonResponse({
        "id": u.id,
        "username": u.username,
        "email": getattr(u, "email", None),
    })

# логаут — баним присланный refresh
@api_view(["POST"])
@permission_classes([IsAuthenticated])
def jwt_logout(request):
    refresh = request.data.get("refresh")
    if not refresh:
        return Response({"detail": "refresh required"}, status=status.HTTP_400_BAD_REQUEST)
    try:
        RefreshToken(refresh).blacklist()
    except Exception:
        return Response({"detail": "invalid refresh"}, status=status.HTTP_400_BAD_REQUEST)
    return Response(status=status.HTTP_204_NO_CONTENT)

# 👇 Защищённые обёртки над твоими уже существующими вьюхами.
#    Никакой магии — просто требуем токен и вызываем старую логику.

@api_view(["GET", "POST"])
@permission_classes([IsAuthenticated])
def get_sum_secure(request, *args, **kwargs):
    return get_sum(request, *args, **kwargs)

@api_view(["GET", "POST"])
@permission_classes([IsAuthenticated])
def get_cached_goods_secure(request, *args, **kwargs):
    return get_cached_goods(request, *args, **kwargs)

@api_view(["GET", "POST"])
@permission_classes([IsAuthenticated])
def get_by_search_secure(request):
    query = request.query_params.get('query')
    return JsonResponse({'data': search(query)})

@api_view(["GET", "POST"])
@permission_classes([IsAuthenticated])
def write_file_secure(request, *args, **kwargs):
    return write_file(request, *args, **kwargs)
# ====== ☝ ДОБАВИТЬ ВНИЗ parser/views.py ☝ ======

@api_view(["POST"])
@permission_classes([AllowAny])
def register(request):
    """
    Принимает JSON:
    { "username": "...", "password": "...", "email": "..." }   # email опционально
    Если username не передали, берём email как username.
    На успех: 201 + {access, refresh}.
    """
    username = (request.data.get("username") or request.data.get("email") or "").strip()
    password = (request.data.get("password") or "").strip()
    email = (request.data.get("email") or "").strip()

    if not username or not password:
        return Response({"detail": "username и password обязательны"}, status=400)

    User = get_user_model()
    try:
        user = User.objects.create_user(username=username, email=email, password=password)
    except IntegrityError:
        return Response({"detail": "username уже занят"}, status=400)

    # сразу логиним «по-взрослому»: выдаём пару токенов
    refresh = RefreshToken.for_user(user)
    return Response(
        {"access": str(refresh.access_token), "refresh": str(refresh)},
        status=status.HTTP_201_CREATED,
    )


'''
----------------------TEST DATA----------------------
START DATE = 02.07.2025
END DATE = 15.07.2025

categories_choice = [
    ['Карты памяти CF', 'Карта памяти SanDisk Extreme CF 64 Gb, 120 Mb/s', '0'],
    ['Жилеты', 'Easyrig Minimax', '0'],
    ['Экшн камеры и 360 ', 'DJI Osmo Pocket 3', '0'],
    ['Фрост рамы', 'Пена 100х100 см серебро/белая', '0']
]

RESULT = 30080 ₽
'''
@api_view(["POST"])
@permission_classes([IsAuthenticated])
def get_cost(request):
    global RAW_PARSE
    categories_choice = request.data.get("data", [])
    date_str = request.data.get("start")
    date_str2   = request.data.get("end")
    date_obj = dt.strptime(date_str, '%d-%m-%Y')
    weekday = date_obj.weekday()
    date_obj2 = dt.strptime(date_str2, '%d-%m-%Y')
    weekday2 = date_obj2.weekday()
    diff_in_days = (date_obj2 - date_obj).days
    result = 0
    categories = RAW_PARSE
    i = 0
    while i < len(categories_choice):
        if categories_choice[i][2] == '1':
            condition = categories[categories_choice[i][0]][categories_choice[i][1]][4]
            del categories_choice[i]
            if not 'бесплатно' in condition.lower():
                price = condition.split(' руб')[0]
                result += int(price)
        else:
            i += 1
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
