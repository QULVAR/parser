from rest_framework.permissions import AllowAny
from rest_framework_simplejwt.views import TokenObtainPairView

class DebugTokenObtainPairView(TokenObtainPairView):
    permission_classes = [AllowAny]
    def post(self, request, *args, **kwargs):
        print("LOGIN DEBUG:", request.data)  # ← увидишь, какие ключи прилетели
        return super().post(request, *args, **kwargs)
