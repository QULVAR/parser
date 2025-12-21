# app/models.py
from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator

class PromoCode(models.Model):
    code = models.CharField(
        max_length=9,
        unique=True,              # промокод один и тот же — не повторяется
        db_index=True,
        help_text="До 9 символов."
    )
    discount = models.PositiveSmallIntegerField(
        validators=[MinValueValidator(0), MaxValueValidator(100)],
        help_text="Целое число 0–100."
    )

    class Meta:
        constraints = [
            models.CheckConstraint(
                check=models.Q(discount__gte=0, discount__lte=100),
                name="discount_between_0_and_100",
            ),
        ]

    def save(self, *args, **kwargs):
        if self.code is not None:
            self.code = self.code.strip()
        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.code} {self.discount}"
