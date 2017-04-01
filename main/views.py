from django.shortcuts import render
from django.views.generic import View

# Create your views here.
class HomeView(View):
  def get(self, request):
    elm_flags = {
      'score': 42,
      'name': "8 bit 1 byte"
    }
    context = {
      'elm_flags': elm_flags,
      'static_file': 'js/home.js'
    }
    return render(request, 'elm.html', context)
