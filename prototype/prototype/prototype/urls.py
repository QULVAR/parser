from django.contrib import admin
from django.urls import path
from parser import views as pviews
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from parser.auth_views import DebugTokenObtainPairView

urlpatterns = [
    path('admin/', admin.site.urls),

    # --- твои старые (публичные/как есть) ---
    path('', pviews.get_sum),
    path('get_goods/', pviews.get_cached_goods),
    path('write_cache/', pviews.write_file),

    # --- JWT ---
    #path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('api/me/', pviews.me, name='me'),
    path('api/logout/', pviews.jwt_logout, name='jwt_logout'),

    # --- защищённые версии твоих ручек (требуют Bearer access) ---
    path('api/get_sum/', pviews.get_sum_secure),
    path('api/get_goods/', pviews.get_cached_goods_secure),
    path('api/search/', pviews.get_by_search_secure),
    path('api/write_cache/', pviews.write_file_secure),
    path('api/register/', pviews.register, name='register'),
    path("api/token/", DebugTokenObtainPairView.as_view(), name="token_obtain_pair"),
]
