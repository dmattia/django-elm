from django.conf.urls import url

from .views import HomeView

urlpatterns = [
  url(
    regex=r"^$",
    view=HomeView.as_view(),
    name="site-home"
  )
]
