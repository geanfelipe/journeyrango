# -*- encoding : utf-8 -*-
from django.contrib import admin
from rango.models import Category, Page

#admin.site.register(Category)
#admin.site.register(Page)


#modify apresentation on admin
class categoryAdmin(admin.ModelAdmin):
	prepopulated_fields = {'slug':('name',)}

class pageAdmin(admin.ModelAdmin):
	list_display = ('title', 'category', 'url')


admin.site.register (Page, pageAdmin)
admin.site.register(Category,categoryAdmin)