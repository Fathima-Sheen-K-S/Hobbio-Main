from django.urls import path
from User import views

app_name = "webuser"
urlpatterns = [

    path('userhome/',views.UserHome,name="userhome"),
    path('userprofile/',views.UserProfile,name="userprofile"),
    path('usereditprofile/',views.UserEditProfile,name="usereditprofile"),
    path('userchangepassword/',views.UserChangePassword,name="userchangepassword"),

    path('usercomplaint/',views.usercomplaint,name="usercomplaint"),

    path('userfeedback/',views.userfeedback,name="userfeedback"),

    path('searchcenters/',views.searchcenters,name="searchcenters"),
    path('ajaxcenter/',views.ajaxcenter,name="ajaxcenter"),

    
]