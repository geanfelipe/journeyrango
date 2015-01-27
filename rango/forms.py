# -*- coding: utf-8 -*-

from django import forms
from rango.models import Category,Page

class CategoryForm(forms.ModelForm):
	name = forms.CharField(max_length=128,help_text="Please enter the Category name")
	views = forms.IntegerField(widget=forms.HiddenInput(),initial=0)
	likes = forms.IntegerField(widget=forms.HiddenInput(),initial=0)
	slug=forms.CharField(widget=forms.HiddenInput(),required=False)

	#field slug ll be populating by the script save in models.py
	#An inline class to provide additional information on the form
	class Meta:
		#association between the model form and a model
		model = Category
		fields = ('name',)

	class PageForms(forms.ModelForm):
		title = forms.CharField(max_length=128,help_text="Please enter the title of the page")
		url = forms.URLField(max_length=200,help_text="Please enter the url of the page")
		views = forms.IntegerField(widget=forms.HiddenInput(),initial=0)

		class Meta:
			#association between the model form and a model
			model = Page
			# What fields do we want to include in our form?
        	# This way we don't need every field in the model present.
        	# Some fields may allow NULL values, so we may not want to include them...
        	# Here, we are hiding the foreign key.
        	# we can either exclude the category field from the form,
        	fields=('title','url','views',)
        	#or specify the fields to include (i.e. not include the category field)
        	#fields = ('title', 'url', 'views')

        def clean(self):
        	cleaned_data = self.cleaned_data
        	url = cleaned_data.get('url')
        	# If url is not empty and doesn't start with 'http://', prepend 'http://'.
        	if url and not url.startswith('http://'):
        		url = 'http://' + url
        		cleaned_data['url'] = url

        		return cleaned_data

        #----
        #n Django 1.7+ it is now required to specify the fields that are included, via fields, or specify the fields that
        #are to be excluded, via exclude.
        #----
