from django.shortcuts import render
from django.http import JsonResponse, FileResponse
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
from .models import PromoCode
from io import BytesIO
import re
import tempfile


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
        raw_data = get_dict_from_file()
        file_path = os.path.join(CACHE_DIR, "raw.json")
        with open(file_path, "w", encoding="utf-8") as f:
            json.dump(raw_data, f, ensure_ascii=False, indent=2)

        goods_data = get_goods(request, False)
        file_path = os.path.join(CACHE_DIR, "data.json")
        with open(file_path, "w", encoding="utf-8") as f:
            json.dump(goods_data, f, ensure_ascii=False, indent=2)

        catalog_data = {'data': get_catalog()}
        file_path = os.path.join(CACHE_DIR, "search.json")
        with open(file_path, "w", encoding="utf-8") as f:
            json.dump(catalog_data, f, ensure_ascii=False, indent=2)

        RAW_PARSE = read_raw_parse()
        GOODS = read_file_goods()
        CATALOG = read_file_catalog()['data']
        return JsonResponse({'result': 'Success'})
    except Exception:
        return JsonResponse({'result': 'Error'})



def get_dict_from_file():
    global RAW_PARSE

    if isinstance(RAW_PARSE, dict):
        return deepcopy(RAW_PARSE)

    file_path = os.path.join(CACHE_DIR, "raw.json")
    if os.path.exists(file_path):
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)
        RAW_PARSE = data
        return deepcopy(data)

    RAW_PARSE = {}
    return {}
    
def get_goods(request, flag = True):
    dict_from_file = get_dict_from_file()
    keys = list(dict_from_file.keys())
    l = 0
    result = {'data': []}

    for category_name in keys:
        result['data'].append({})
        result['data'][-1]['category'] = category_name
        result['data'][-1]['items'] = []

        keys_items = list(dict_from_file[category_name].keys())
        for item_name in keys_items:
            raw_price = dict_from_file[category_name][item_name]
            price = list(raw_price) if isinstance(raw_price, list) else raw_price

            result['data'][-1]['items'].append({})
            result['data'][-1]['items'][-1]['item'] = item_name
            l = max(l, len(item_name))
            result['data'][-1]['items'][-1]['price'] = price

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


def is_I_admin(request):
    u = request.user
    file_path = os.path.join(CACHE_DIR, "admins.json")
    with open(file_path, "r", encoding="utf-8") as f:
        admins = json.load(f)["admins"]
    return u.username in admins


# Helper functions for accounts management
def read_admins_list():
    file_path = os.path.join(CACHE_DIR, "admins.json")
    with open(file_path, "r", encoding="utf-8") as f:
        return json.load(f).get("admins", [])

def write_admins_list(admins):
    file_path = os.path.join(CACHE_DIR, "admins.json")
    with open(file_path, "w", encoding="utf-8") as f:
        json.dump({"admins": admins}, f, ensure_ascii=False, indent=2)

def is_valid_email(email):
    if not isinstance(email, str):
        return False
    email = email.strip()
    return re.fullmatch(r"[^@\s]+@[^@\s]+\.[^@\s]+", email) is not None

def is_valid_password(password):
    return isinstance(password, str) and len(password) >= 7

# "кто я" — аналог request.user в шаблоне
@api_view(["GET"])
@permission_classes([IsAuthenticated])
def me(request):
    u = request.user
    file_path = os.path.join(CACHE_DIR, "admins.json")
    with open(file_path, "r", encoding="utf-8") as f:
        admins = json.load(f)["admins"]
    role = 'admin' if is_I_admin(request) else 'user'
    return JsonResponse({
        "id": u.id,
        "username": u.username,
        "email": getattr(u, "email", None),
        "role": role
    })


###                                 PROMO


@api_view(["POST"])
@permission_classes([IsAuthenticated])
def promos(request):
    if not is_I_admin(request):
        return JsonResponse({
            "status": "error",
            "Unauthorized" : 0
        })
    all_promos = PromoCode.objects.all()
    result = dict()
    for i in all_promos:
        promo, percent = str(i).split()
        result[promo] = int(percent)
    return JsonResponse(result)
    

@api_view(["POST"])
@permission_classes([IsAuthenticated])
def promos_create(request):
    if not is_I_admin(request):
        return JsonResponse({
            "status": "error",
            "Unauthorized" : 0
        })
    try:
        promo = PromoCode(code=request.data.get("new_promo"), discount=request.data.get("percent"))
        promo.save()
        return JsonResponse({"status": "success"})
    except:
        return JsonResponse({"status": "error"})


def create_promo(request):
    try:
        promo = PromoCode(code=request.data.get("new_promo"), discount=request.data.get("percent"))
        promo.save()
        return JsonResponse({"status": "success"})
    except:
        return JsonResponse({"status": "error"})
        

@api_view(["POST"])
@permission_classes([IsAuthenticated])
def promos_update(request):
    if not is_I_admin(request):
        return JsonResponse({
            "status": "error",
            "Unauthorized" : 0
        })
    try:
        promo = PromoCode.objects.get(code=request.data.get("promo"))
        promo.code = request.data.get("new_promo")
        promo.discount = request.data.get("percent")
        promo.save()
        return JsonResponse({"status": "success"})
    except:
        return create_promo(request)


@api_view(["POST"])
@permission_classes([IsAuthenticated])
def promos_delete(request):
    if not is_I_admin(request):
        return JsonResponse({
            "status": "error",
            "Unauthorized" : 0
        })
    try:
        promo = PromoCode.objects.get(code=request.data.get("promo"))
        promo.delete()
        return JsonResponse({"status": "success"})
    except:
        return JsonResponse({"status": "error"})
        


###                                 PROMO


###                                 ACCOUNTS


@api_view(["POST"])
@permission_classes([IsAuthenticated])
def accounts(request):
    if not is_I_admin(request):
        return JsonResponse({
            "status": "error",
            "Unauthorized": 0
        })

    User = get_user_model()
    admins = set(read_admins_list())
    result = []

    for user in User.objects.all().order_by("id"):
        email = (getattr(user, "email", "") or "").strip()
        if email == "":
            continue
        result.append({
            "email": email,
            "is_admin": email in admins
        })

    return JsonResponse({
        "status": "success",
        "list": result
    })


@api_view(["POST"])
@permission_classes([IsAuthenticated])
def accounts_create(request):
    if not is_I_admin(request):
        return JsonResponse({
            "status": "error",
            "Unauthorized": 0
        })

    email = (request.data.get("email") or "").strip()
    password = request.data.get("password") or ""
    is_admin = bool(request.data.get("is_admin"))

    if not is_valid_email(email):
        return JsonResponse({"status": "error", "email": "invalid"})
    if not is_valid_password(password):
        return JsonResponse({"status": "error", "password": "invalid"})

    User = get_user_model()
    if User.objects.filter(email=email).exists() or User.objects.filter(username=email).exists():
        return JsonResponse({"status": "error", "email": "already_exists"})

    try:
        user = User.objects.create_user(username=email, email=email, password=password)
        admins = read_admins_list()
        if is_admin and email not in admins:
            admins.append(email)
            write_admins_list(admins)
        return JsonResponse({"status": "success"})
    except IntegrityError:
        return JsonResponse({"status": "error", "email": "already_exists"})
    except Exception:
        return JsonResponse({"status": "error"})


def create_account(request):
    email = (request.data.get("email") or request.data.get("new_email") or "").strip()
    password = request.data.get("password") or request.data.get("new_password") or ""
    is_admin = bool(request.data.get("is_admin"))

    if not is_valid_email(email):
        return JsonResponse({"status": "error", "email": "invalid"})
    if not is_valid_password(password):
        return JsonResponse({"status": "error", "password": "invalid"})

    User = get_user_model()
    if User.objects.filter(email=email).exists() or User.objects.filter(username=email).exists():
        return JsonResponse({"status": "error", "email": "already_exists"})

    try:
        User.objects.create_user(username=email, email=email, password=password)
        admins = read_admins_list()
        if is_admin and email not in admins:
            admins.append(email)
            write_admins_list(admins)
        return JsonResponse({"status": "success"})
    except IntegrityError:
        return JsonResponse({"status": "error", "email": "already_exists"})
    except Exception:
        return JsonResponse({"status": "error"})


@api_view(["POST"])
@permission_classes([IsAuthenticated])
def accounts_update(request):
    if not is_I_admin(request):
        return JsonResponse({
            "status": "error",
            "Unauthorized": 0
        })

    old_email = (request.data.get("old_email") or request.data.get("email") or "").strip()
    new_email = (request.data.get("new_email") or "").strip()
    new_password = request.data.get("new_password") or request.data.get("password") or ""
    is_admin = bool(request.data.get("is_admin"))

    if not is_valid_email(old_email) or not is_valid_email(new_email):
        return JsonResponse({"status": "error", "email": "invalid"})
    if new_password != "" and not is_valid_password(new_password):
        return JsonResponse({"status": "error", "password": "invalid"})

    User = get_user_model()
    try:
        user = User.objects.get(email=old_email)
    except User.DoesNotExist:
        return create_account(request)

    if old_email != new_email:
        email_exists = User.objects.filter(email=new_email).exclude(id=user.id).exists()
        username_exists = User.objects.filter(username=new_email).exclude(id=user.id).exists()
        if email_exists or username_exists:
            return JsonResponse({"status": "error", "email": "already_exists"})

    try:
        previous_email = (user.email or "").strip()
        user.email = new_email
        user.username = new_email
        if new_password != "":
            user.set_password(new_password)
        user.save()

        admins = read_admins_list()
        admins = [admin for admin in admins if admin != previous_email]
        if is_admin and new_email not in admins:
            admins.append(new_email)
        write_admins_list(admins)

        return JsonResponse({"status": "success"})
    except Exception:
        return JsonResponse({"status": "error"})


@api_view(["POST"])
@permission_classes([IsAuthenticated])
def accounts_delete(request):
    if not is_I_admin(request):
        return JsonResponse({
            "status": "error",
            "Unauthorized": 0
        })

    email = (request.data.get("email") or "").strip()
    if not is_valid_email(email):
        return JsonResponse({"status": "error", "email": "invalid"})

    User = get_user_model()
    try:
        user = User.objects.get(email=email)
        user.delete()
        admins = [admin for admin in read_admins_list() if admin != email]
        write_admins_list(admins)
        return JsonResponse({"status": "success"})
    except User.DoesNotExist:
        return JsonResponse({"status": "error"})
    except Exception:
        return JsonResponse({"status": "error"})


###                                 ACCOUNTS

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
def calculate_item_cost(categories, choice, date_str, date_str2):
    category_name = choice[0]
    item_name = choice[1]
    has_special_condition = len(choice) > 2 and choice[2] == '1'

    item_data = categories[category_name][item_name]

    if has_special_condition:
        condition = item_data[4]
        if 'бесплатно' in condition.lower():
            return 0
        price = condition.split(' руб')[0]
        return int(price)

    date_obj = dt.strptime(date_str, '%d-%m-%Y')
    weekday = date_obj.weekday()
    date_obj2 = dt.strptime(date_str2, '%d-%m-%Y')
    weekday2 = date_obj2.weekday()
    diff_in_days = (date_obj2 - date_obj).days
    result = 0

    while diff_in_days != 0:
        if diff_in_days >= 7:
            diff_in_days -= 7
            result += item_data[1]
        else:
            if weekday > weekday2:
                if weekday == 4:
                    result += item_data[0]
                    weekday = 1
                    diff_in_days -= 4
                elif weekday == 5:
                    result += item_data[0]
                    weekday = 1
                    diff_in_days -= 3
                elif weekday < 4:
                    result += item_data[0]
                    weekday += 1
                    diff_in_days -= 1
                elif weekday == 6:
                    result += item_data[0]
                    weekday = 0
                    diff_in_days -= 1
                else:
                    raise ValueError
            else:
                result += item_data[0] * diff_in_days
                diff_in_days = 0

    return result

# ==== build_estimate_data helper ====
def build_estimate_data(categories, categories_choice, date_str, date_str2, promocode):
    aggregated = {}
    subtotal = 0

    for choice in categories_choice:
        category_name = choice[0]
        item_name = choice[1]
        special_flag = choice[2] if len(choice) > 2 else '0'
        key = (category_name, item_name, special_flag)

        item_total = calculate_item_cost(categories, choice, date_str, date_str2)
        subtotal += item_total

        if key not in aggregated:
            aggregated[key] = {
                'category': category_name,
                'item': item_name,
                'qty': 0,
                'unit_price': item_total,
                'line_total': 0,
                'special_flag': special_flag,
            }

        aggregated[key]['qty'] += 1
        aggregated[key]['line_total'] += item_total

    items = list(aggregated.values())
    items.sort(key=lambda x: (x['category'], x['item']))

    discount_percent = 0
    promo_exists = True
    applied_promocode = promocode if promocode != '' else None

    if promocode != '':
        try:
            promo = PromoCode.objects.get(code=promocode)
            discount_percent = int(promo.discount)
        except PromoCode.DoesNotExist:
            promo_exists = False

    discount_amount = 0
    total = subtotal
    if promo_exists and discount_percent > 0:
        discount_amount = subtotal * discount_percent / 100
        total = subtotal - discount_amount

    try:
        dt_start = dt.strptime(date_str, '%d-%m-%Y')
        dt_end = dt.strptime(date_str2, '%d-%m-%Y')
        days = (dt_end - dt_start).days
        formatted_start = dt_start.strftime('%d.%m.%Y')
        formatted_end = dt_end.strftime('%d.%m.%Y')
    except Exception:
        days = 0
        formatted_start = date_str
        formatted_end = date_str2

    return {
        'status': 'success',
        'start': formatted_start,
        'end': formatted_end,
        'days': days,
        'items': items,
        'subtotal': subtotal,
        'discount_percent': discount_percent,
        'discount_amount': discount_amount,
        'total': total,
        'promocode': applied_promocode,
        'promo_status': 'success' if promo_exists else 'promo_404',
    }


def estimate_items_to_pdf_rows(estimate_items):
    rows = []
    for item in estimate_items:
        rows.append((
            item['item'],
            item['qty'],
            item['unit_price'],
            item['line_total'],
        ))
    return rows


@api_view(["POST"])
@permission_classes([IsAuthenticated])
def get_cost(request):
    global RAW_PARSE
    categories_choice = request.data.get("data", [])
    date_str = request.data.get("start")
    date_str2 = request.data.get("end")
    promocode = request.data.get("promo")
    categories = RAW_PARSE

    estimate = build_estimate_data(categories, categories_choice, date_str, date_str2, promocode)
    return JsonResponse({
        'result': estimate['total'],
        'result_without_promo': estimate['subtotal'],
        'promo_status': estimate['promo_status']
    })


# ==== get_estimate endpoint ====
@api_view(["POST"])
@permission_classes([IsAuthenticated])
def get_estimate(request):
    global RAW_PARSE
    categories_choice = request.data.get("data", [])
    date_str = request.data.get("start")
    date_str2 = request.data.get("end")
    promocode = request.data.get("promo")
    categories = RAW_PARSE

    estimate = build_estimate_data(categories, categories_choice, date_str, date_str2, promocode)
    return JsonResponse(estimate)


def generate_smeta_pdf(
    output_target,
    logo_path: str,
    start_date: str,
    end_date: str,
    items: list[tuple[str, int, float, float]],
    promocode: str,
    discount_percent: float,
    company_name: str,
) -> None:

    from datetime import datetime
    from reportlab.lib.pagesizes import A4
    from reportlab.pdfgen import canvas
    from reportlab.lib.units import mm
    from reportlab.lib.colors import HexColor
    from reportlab.lib.utils import ImageReader
    from reportlab.pdfbase import pdfmetrics
    from reportlab.pdfbase.ttfonts import TTFont

    pdfmetrics.registerFont(TTFont('DejaVuSans', os.path.join(settings.BASE_DIR, 'parser', 'static', 'files', 'DejaVuSans.ttf')))
    pdfmetrics.registerFont(TTFont('DejaVuSans-Bold', os.path.join(settings.BASE_DIR, 'parser', 'static', 'files', 'DejaVuSans-Bold.ttf')))

    COLOR_GREEN = HexColor('#009E3A')
    COLOR_LIGHT_GREY = HexColor('#F5F5F5')
    COLOR_MEDIUM_GREY = HexColor('#E6E6E6')
    COLOR_DARK_TEXT = HexColor('#333333')

    FONT_HEADER = 16
    FONT_PERIOD = 11
    FONT_TABLE_HEADER = 9
    FONT_TABLE_BODY = 9
    FONT_SUMMARY_LABEL = 8
    FONT_SUMMARY_VALUE = 12
    FONT_FOOTER = 8
    
    subtotal = sum(amount for _, _, _, amount in items)
    discount_amount = subtotal * discount_percent / 100
    final_total = subtotal - discount_amount

    c = canvas.Canvas(output_target, pagesize=A4)
    page_width, page_height = A4

    margin = 20 * mm
    content_width = page_width - 2 * margin

    inner_margin = 8 * mm
    inner_x = margin + inner_margin
    inner_width = content_width - 2 * inner_margin
    header_row_height = 16 * mm
    row_height = 14 * mm

    columns_shift = 18 * mm

    pos_col_width = inner_width * 0.44
    qty_col_width = inner_width * 0.14
    rate_col_width = inner_width * 0.18
    sum_col_width = inner_width - pos_col_width - qty_col_width - rate_col_width

    qty_x = inner_x + pos_col_width + columns_shift
    rate_x = qty_x + qty_col_width
    sum_x = rate_x + rate_col_width

    try:
        dt_start = datetime.strptime(start_date, '%d.%m.%Y')
        dt_end = datetime.strptime(end_date, '%d.%m.%Y')
        days = (dt_end - dt_start).days
    except Exception:
        try:
            dt_start = datetime.strptime(start_date, '%d.%m.%Y %H:%M')
            dt_end = datetime.strptime(end_date, '%d.%m.%Y %H:%M')
            days = (dt_end - dt_start).days
        except Exception:
            days = 0

    def draw_first_page_header() -> float:
        header_height = 25 * mm
        c.setFillColor(COLOR_GREEN)
        c.roundRect(
            margin,
            page_height - margin - header_height,
            content_width,
            header_height,
            4,
            stroke=0,
            fill=1
        )

        logo = ImageReader(logo_path)
        logo_height = 15 * mm
        logo_width = logo_height * (logo.getSize()[0] / logo.getSize()[1])
        logo_x = margin + 10 * mm
        logo_y = page_height - margin - header_height + (header_height - logo_height) / 2

        padding = 2 * mm
        c.setFillColor('white')
        c.roundRect(
            logo_x - padding,
            logo_y - padding,
            logo_width + 2 * padding,
            logo_height + 2 * padding,
            3,
            stroke=0,
            fill=1
        )
        c.drawImage(logo, logo_x, logo_y, logo_width, logo_height, mask='auto')

        c.setFont('DejaVuSans-Bold', FONT_HEADER)
        c.setFillColor('white')
        c.drawString(
            logo_x + logo_width + 8 * mm,
            page_height - margin - header_height / 2 - 5,
            'Амерта • Смета по аренде'
        )

        current_y_local = page_height - margin - header_height - 10 * mm

        period_height = 20 * mm
        c.setFillColor(COLOR_LIGHT_GREY)
        c.roundRect(
            margin,
            current_y_local - period_height,
            content_width,
            period_height,
            4,
            stroke=0,
            fill=1
        )
        
        days_label = ''
        if days % 10 == 1 and days % 100 != 11:
            days_label = 'день'
        elif days % 10 in [2, 3, 4] and days % 100 not in [12, 13, 14]:
            days_label = 'дня'
        else:
            days_label = 'дней'

        period_text = f'{days} {days_label} • {start_date} - {end_date}'
        c.setFont('DejaVuSans-Bold', FONT_PERIOD)
        c.setFillColor(COLOR_DARK_TEXT)
        text_width = c.stringWidth(period_text, 'DejaVuSans-Bold', FONT_PERIOD)
        c.drawString(
            margin + (content_width - text_width) / 2,
            current_y_local - period_height / 2 + 4,
            period_text
        )

        return current_y_local - period_height - 12 * mm

    def draw_plain_page_top() -> float:
        return page_height - margin - 10 * mm

    def draw_table_header(current_y_local: float) -> float:
        c.setFont('DejaVuSans-Bold', FONT_TABLE_HEADER + 1)
        c.setFillColor(COLOR_GREEN)
        header_baseline = current_y_local - header_row_height / 2 + 2
        c.drawString(inner_x + 2, header_baseline, 'Позиция')
        c.drawString(qty_x + 2, header_baseline, 'Кол-во')
        c.drawString(rate_x + 2, header_baseline, 'Ставка')
        c.drawString(sum_x + 2, header_baseline, 'Сумма')

        current_row_y_local = current_y_local - header_row_height
        c.setStrokeColor(COLOR_MEDIUM_GREY)
        c.setLineWidth(0.5)
        c.line(inner_x, current_row_y_local, inner_x + inner_width, current_row_y_local)
        return current_row_y_local

    def draw_footer() -> None:
        c.setFont('DejaVuSans', FONT_FOOTER)
        c.setFillColor(COLOR_DARK_TEXT)
        c.drawString(margin, margin + 5, company_name)
        timestamp = datetime.now().strftime('%d.%m.%Y %H:%M')
        c.drawRightString(
            margin + content_width,
            margin + 5,
            f'Сформировано: {timestamp}'
        )

    def start_new_page() -> float:
        c.showPage()
        top_y = draw_plain_page_top()
        return draw_table_header(top_y)

    current_y = draw_first_page_header()
    current_row_y = draw_table_header(current_y)

    c.setFont('DejaVuSans', FONT_TABLE_BODY)
    c.setFillColor(COLOR_DARK_TEXT)

    bottom_reserved = 55 * mm

    for name, qty, rate, amount in items:
        if current_row_y - row_height < margin + bottom_reserved:
            current_row_y = start_new_page()
            c.setFont('DejaVuSans', FONT_TABLE_BODY)
            c.setFillColor(COLOR_DARK_TEXT)

        text_y = current_row_y - row_height / 2

        c.drawString(inner_x + 2, text_y, name)
        c.drawRightString(qty_x + qty_col_width - 38, text_y, str(qty))

        rate_str = f'{rate:,.0f} ₽'.replace(',', ' ')
        c.drawRightString(rate_x + rate_col_width - 38, text_y, rate_str)

        amount_str = f'{amount:,.0f} ₽'.replace(',', ' ')
        c.drawRightString(sum_x + sum_col_width - 69, text_y, amount_str)

        current_row_y -= row_height
        c.setStrokeColor(COLOR_MEDIUM_GREY)
        c.setLineWidth(0.5)
        c.line(inner_x, current_row_y, inner_x + inner_width, current_row_y)

    needed_space = row_height * 2 + 22 * mm + 20 * mm
    if current_row_y - needed_space < margin + 20 * mm:
        current_row_y = start_new_page()
        c.setFont('DejaVuSans', FONT_TABLE_BODY)
        c.setFillColor(COLOR_DARK_TEXT)

    promo_y = current_row_y - row_height / 2
    c.setFont('DejaVuSans-Bold', FONT_TABLE_BODY + 1)
    c.setFillColor(COLOR_DARK_TEXT)
    c.drawString(inner_x + 2, promo_y, 'Промокод')
    c.setFont('DejaVuSans', FONT_TABLE_BODY)
    c.drawString(qty_x + 15, promo_y, promocode)

    current_row_y -= row_height
    c.setStrokeColor(COLOR_MEDIUM_GREY)
    c.line(inner_x, current_row_y, inner_x + inner_width, current_row_y)

    disc_y = current_row_y - row_height / 2
    c.setFont('DejaVuSans-Bold', FONT_TABLE_BODY + 1)
    c.setFillColor(COLOR_DARK_TEXT)
    c.drawString(inner_x + 2, disc_y, 'Скидка')
    c.setFont('DejaVuSans', FONT_TABLE_BODY)
    c.drawString(qty_x + 15, disc_y, f'{discount_percent}%')

    discount_str = f'- {discount_amount:,.0f} ₽'.replace(',', ' ')
    c.drawRightString(sum_x + sum_col_width - 69, disc_y, discount_str)

    current_row_y -= row_height
    c.setStrokeColor(COLOR_MEDIUM_GREY)
    c.line(inner_x, current_row_y, inner_x + inner_width, current_row_y)

    summary_margin = 8 * mm
    summary_width = rate_col_width + sum_col_width + qty_col_width * 0.75
    summary_height = 22 * mm
    summary_x = inner_x + inner_width - summary_width
    summary_y = current_row_y - summary_height - summary_margin

    c.setFillColor(COLOR_LIGHT_GREY)
    c.roundRect(summary_x, summary_y, summary_width, summary_height, 4, stroke=0, fill=1)

    c.setFont('DejaVuSans-Bold', FONT_TABLE_BODY + 7)
    c.setFillColor(COLOR_DARK_TEXT)
    c.drawString(summary_x + 10, summary_y + summary_height - 20, 'Итоговая стоимость')

    c.setFont('DejaVuSans-Bold', FONT_SUMMARY_VALUE + 2)
    c.setFillColor(COLOR_GREEN)
    total_str = f'{final_total:,.0f} ₽'.replace(',', ' ')
    c.drawRightString(summary_x + summary_width - 15, summary_y + 15, total_str)

    draw_footer()
    c.showPage()
    c.save()



@api_view(["POST"])
@permission_classes([IsAuthenticated])
def get_estimate_pdf(request):
    global RAW_PARSE
    categories_choice = request.data.get("data", [])
    date_str = request.data.get("start")
    date_str2 = request.data.get("end")
    promocode = request.data.get("promo")
    categories = RAW_PARSE

    estimate = build_estimate_data(categories, categories_choice, date_str, date_str2, promocode)

    pdf_buffer = BytesIO()
    logo_path = os.path.join(settings.BASE_DIR, 'parser', 'static', 'files', 'logo.png')

    generate_smeta_pdf(
        output_target=pdf_buffer,
        logo_path=logo_path,
        start_date=estimate["start"],
        end_date=estimate["end"],
        items=estimate_items_to_pdf_rows(estimate["items"]),
        promocode=estimate["promocode"] or "",
        discount_percent=estimate["discount_percent"],
        company_name="Амерта",
    )

    pdf_buffer.seek(0)

    return FileResponse(
        pdf_buffer,
        as_attachment=True,
        filename="smeta.pdf",
        content_type="application/pdf",
    )


def normalize_cell(val):
    if pd.isna(val):
        return val

    s = str(val)
    s = s.replace('\r\n', '\n').replace('\r', '\n')
    s = s.replace('\xa0', ' ')
    s = s.replace('\u00ad', '')

    # Кам\nера -> Камера
    s = re.sub(r'(?<=\w)\n(?=\w)', '', s)

    # остальные переносы -> пробел
    s = s.replace('\n', ' ')

    # схлопываем пробелы
    s = re.sub(r'\s+', ' ', s).strip()
    return s


def maybe_number(x):
    if isinstance(x, str):
        x = x.strip()
        if re.fullmatch(r'\d+', x):
            return int(x)
    return x


def clean_repeats(row):
    cleaned = []
    for val in row:
        if not pd.isna(val):
            cleaned.append(maybe_number(val))
    return cleaned


def build_raw_from_excel_file(file_path):
    df = pd.read_excel(file_path, header=None)

    # чистим весь excel поячеечно
    df = df.map(normalize_cell)

    cleaned = []
    for row in df.itertuples(index=False):
        cleaned.append(clean_repeats(list(row)))

    categories = {}
    category = ''
    last_added = ''

    cleaned = cleaned[5:]

    for row in cleaned:
        if len(row) == 0:
            continue

        first = row[0]

        if first == 'Наименование товара':
            continue

        if len(row) == 1:
            if isinstance(first, str) and 'при аренде' in first.lower():
                if category and last_added and category in categories and last_added in categories[category]:
                    categories[category][last_added].append(first.strip())

            elif first == '(Цена за 24 часа)':
                pass

            else:
                if isinstance(first, str) and first.strip() != '':
                    category_name = first.strip()
                    if category_name not in categories:
                        categories[category_name] = {}
                    category = category_name

        else:
            if category == '' or category not in categories:
                continue

            item_name = row[0]
            item_values = row[1:]

            if not isinstance(item_name, str):
                continue

            item_name = item_name.strip()
            if item_name == '':
                continue

            normalized_values = []
            for value in item_values:
                if isinstance(value, str):
                    normalized_values.append(value.strip())
                else:
                    normalized_values.append(value)

            categories[category][item_name] = normalized_values
            last_added = item_name

    for key in list(categories.keys()):
        if categories[key] == {}:
            del categories[key]

    # финальный strip ключей
    clean_categories = {}

    for category_name, items in categories.items():
        fixed_category = category_name.strip() if isinstance(category_name, str) else category_name

        if fixed_category not in clean_categories:
            clean_categories[fixed_category] = {}

        for item_name, item_values in items.items():
            fixed_item = item_name.strip() if isinstance(item_name, str) else item_name
            clean_categories[fixed_category][fixed_item] = item_values

    return clean_categories


@api_view(["POST"])
@permission_classes([IsAuthenticated])
def upload_catalog_excel(request):
    if not is_I_admin(request):
        return JsonResponse({
            "status": "error",
            "Unauthorized": 0
        })

    uploaded_file = request.FILES.get("file")
    if uploaded_file is None:
        return JsonResponse({
            "status": "error",
            "message": "file is required"
        }, status=400)

    if not uploaded_file.name.lower().endswith(".xlsx"):
        return JsonResponse({
            "status": "error",
            "message": "only .xlsx is allowed"
        }, status=400)

    tmp_path = None

    try:
        with tempfile.NamedTemporaryFile(delete=False, suffix=".xlsx") as tmp:
            for chunk in uploaded_file.chunks():
                tmp.write(chunk)
            tmp_path = tmp.name

        raw_data = build_raw_from_excel_file(tmp_path)

        file_path = os.path.join(CACHE_DIR, "raw.json")
        with open(file_path, "w", encoding="utf-8") as f:
            json.dump(raw_data, f, ensure_ascii=False, indent=2)

        global RAW_PARSE
        RAW_PARSE = raw_data

        file_path = os.path.join(CACHE_DIR, "data.json")
        with open(file_path, "w", encoding="utf-8") as f:
            json.dump(get_goods(request, False), f, ensure_ascii=False, indent=2)

        file_path = os.path.join(CACHE_DIR, "search.json")
        with open(file_path, "w", encoding="utf-8") as f:
            json.dump({'data': get_catalog()}, f, ensure_ascii=False, indent=2)

        global GOODS, CATALOG
        GOODS = read_file_goods()
        CATALOG = read_file_catalog()['data']

        return JsonResponse({
            "status": "success",
        })

    except Exception as e:
        return JsonResponse({
            "status": "error",
            "message": str(e)
        }, status=500)

    finally:
        if tmp_path and os.path.exists(tmp_path):
            os.remove(tmp_path)


@api_view(["POST"])
@permission_classes([IsAuthenticated])
def clear_catalog(request):
    if not is_I_admin(request):
        return JsonResponse({
            "status": "error",
            "Unauthorized": 0
        })
    try:
        os.remove(os.path.join(CACHE_DIR, "raw.json"))
        os.remove(os.path.join(CACHE_DIR, "data.json"))
        os.remove(os.path.join(CACHE_DIR, "search.json"))
        return JsonResponse({
            "status": "success"
        })
    except e as Exception:
        return JsonResponse({
            "status": "error",
            "message": str(e)
        })
