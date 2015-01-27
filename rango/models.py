# -*- coding: utf-8 -*-

from django.db import models
from django.template.defaultfilters import slugify
from django.contrib.auth.models import User
import datetime

class Category(models.Model):
	name = models.CharField(max_length=128, unique=True)
	views = models.IntegerField(default=0)
	likes = models.IntegerField(default=0)
	slug = models.SlugField(unique=True)
	
	def save(self, *args, **kwargs):
		self.slug = slugify(self.name)
		super(Category,self).save(*args,**kwargs)
	
	#equals to __str__
	def __unicode__(self):
		return self.name
		#return u"%s - %d %d" %(self.name,self.views,self.likes)

class Page(models.Model):
	category = models.ForeignKey(Category)
	title = models.CharField(max_length=128)
	url = models.URLField()
	views= models.IntegerField(default=0)

	#equals to __str__
	def __unicode__(self):
		return self.title

class UserProfile(models.Model):
	#this line is required. User model instance
	user = models.OneToOneField(User)

	#additional attributes to include
	#allows users need not fill in these fields
	website = models.URLField(blank=True)
	picture = models.ImageField(upload_to='profile_images',blank=True)

	def __unicode__(self):
		return self.user.username
