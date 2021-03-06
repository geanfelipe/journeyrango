# -*- coding: utf-8 -*-

from django.shortcuts import render,render_to_response
from django.http import HttpResponse,HttpResponseRedirect
from rango.models import Category,Page,UserProfile
from rango.forms import CategoryForm,PageForms,UserForm,UserProfileForm
from django.template.response import TemplateResponse
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from datetime import datetime
from bing_search import run_query
def index(request):

    # Query the database for a list of ALL categories currently stored.
	# Order the categories by no. likes in descending order.
    # Retrieve the top 5 only - or all if less than 5.
    # Place the list in our context_dict dictionary which will be passed to the template engine.
    context_dict={}
    
    category_list = Category.objects.all()
    page_list = Page.objects.order_by('-views')[:5]

    context_dict['categories'] = category_list
    context_dict['pages']= page_list

    visits = request.session.get('visits')

    if not visits:
        visits = 1
    reset_last_visit_time = False

    last_visit  = request.session.get('last_visit')
    if last_visit:
        last_visit_time = datetime.strptime(last_visit[:-7], "%Y-%m-%d %H:%M:%S")

        if (datetime.now() - last_visit_time).seconds > 10:
            visits +=1
            #and update the last cookie
            reset_last_visit_time = False

    response = render(request, 'rango/index.html',context_dict)

    if 'last_visit' in request.COOKIES:
        #get cookie value
        last_visit = request.COOKIES['last_visit']
        #cast to python date
        last_visit_time = datetime.strptime(last_visit[:-7],"%Y-%m-%d %H:%M:%S")

        #if it's been more than a day since that the last visit
        if (datetime.now() - last_visit_time).seconds > 10:
            visits +=1
            reset_last_visit_time= True

    else:
        #last_visit doen't exist , update
        reset_last_visit_time = True
        context_dict['visits']= visits
        response= render(request, 'rango/index.html',context_dict)

    if reset_last_visit_time:
        response.set_cookie('last_visit',datetime.now())        
        response.set_cookie('visits',visits)

    return response

    most_viewed = Page.objects.order_by('-views')[:5]
    context_dict['viewed'] = most_viewed

    # Render the response and send it back!
    return render(request, 'rango/index.html', context_dict)

def category(request, category_name_slug):

    # Create a context dictionary which we can pass to the template rendering engine.
    context_dict = {}

    try:
        # Can we find a category name slug with the given name?
        # If we can't, the .get() method raises a DoesNotExist exception.
        # So the .get() method returns one model instance or raises an exception.
        category = Category.objects.get(slug=category_name_slug)
        context_dict['category_name'] = category.name

        # Retrieve all of the associated pages.
        # Note that filter returns >= 1 model instance.
        pages = Page.objects.filter(category=category)

        # Adds our results list to the template context under name pages.
        context_dict['pages'] = pages
        # We also add the category object from the database to the context dictionary.
        # We'll use this in the template to verify that the category exists.
        context_dict['category'] = category
    except Category.DoesNotExist:
        # We get here if we didn't find the specified category.
        # Don't do anything - the template displays the "no category" message for us.
        pass

    # Go render the response and return it to the client.

    return render(request, 'rango/category.html', context_dict)

def add_category(request):
    #it's a http post?
    if request.method == 'POST':
        form = CategoryForm(request.POST)

        if form.is_valid():
            #save the new category to the database
            form.save(commit=True)

            #now call the index view
            #the user ll be shown the homepage
            
            #return HttpResponseRedirect("/rango/")
            return TemplateResponse(request, 'rango/saved.html', {})
            
        else:
            #print them to the terminal
            print form.errors
    else:
        #if was not a post, display the form to enter details
        form = CategoryForm()

    return render(request,'rango/add_category.html',{'form':form})

@login_required
def add_page(request,category_name_slug):
    try:
        cat = Category.objects.get(slug=category_name_slug)
    except Category.DoesNotExist:
        cat = None
        
    if request.method=='POST':
        form = PageForms(request.POST)
        if form.is_valid():
            if cat:
                page = form.save(commit=False)
                page.category=cat
                page.views= 0
                page.save()
                #return TemplateResponse(request, 'rango/saved.html', {})
                return category(request,category_name_slug)
        else:
            print form.errors
    else:
        form = PageForms()

    context_dict= {'form':form, 'category':cat, 'link':cat.slug}

    return render(request,'rango/add_page.html',context_dict)

def register(request):
    registred = False


    if request.method== 'POST':
        user_form = UserForm(data=request.POST)
        profile_form = UserProfileForm(data=request.POST)

        #if the two form are valid
        if user_form.is_valid() and profile_form.is_valid():
            #save the user's form data to the database
            user = user_form.save()

            #hash the passw with set_password method
            #once hashed, can update the user object
            user.set_password(user.password)
            user.save()

            profile = profile_form.save(commit=False)
            profile.user = user

            # Did the user provide a profile picture?
            # If so, we need to get it from the input form and put it in the UserProfile model.
            if 'picture' in request.FILES:
                profile.picture = request.FILES['picture']

            #now save the userprofile model instance
            profile.save()

            #update our variable to tell the template registration was succesfull
            registred = True

        #invalid form 
        else:
            print user_form.errors, profile_form.errors
    
    else:
        user_form = UserForm()
        profile_form = UserProfileForm()

    return render(request,'rango/register.html',{'user_form':user_form,'profile_form':profile_form,'registred':registred})

def user_login(request):

    if request.method=='POST':
        username = request.POST['username']
        password = request.POST['password']

        user = authenticate(username=username, password=password)
        if user:
            
            #is the account active?
            if user.is_active:
                login(request,user)
                return HttpResponseRedirect('/rango/')
            else:
                return HttpResponse("Your Rango account is disabled")
        else:
            #bad login details were provided , so can't log the user in
            print "Invalid login details: {0}, {1}".format(username,password)        

            return HttpResponse("Invalid login details supplied",{})
    
    #the request is not a http post, so display the login form
    else:
        return render(request,'rango/login.html',{})

@login_required
def restricted(request):
    """
    if the user is not logged then it redirect another \
    page, defined in the URL 
    """
    return HttpResponse("since you are logged in, you can see this test!")

@login_required
def user_logout(request):
    logout(request)

    #take the user back to the homepage
    return HttpResponseRedirect('/rango/')

def about(request):
    visits = int(request.COOKIES.get('visits', '1'))

    context_dict = {}

    visits = request.session.get('visits')
    if not visits:
        visits = 1
    reset_last_visit_time = False

    last_visit = request.session.get('last_visit')
    if last_visit:
        last_visit_time = datetime.strptime(last_visit[:-7], "%Y-%m-%d %H:%M:%S")

        if (datetime.now() - last_visit_time).seconds > 3600:
            # ...reassign the value of the cookie to +1 of what it was before...
            visits = visits + 1
            # ...and update the last visit cookie, too.
            reset_last_visit_time = True
    else:
        # Cookie last_visit doesn't exist, so create it to the current date/time.
        reset_last_visit_time = True

    if reset_last_visit_time:
        request.session['last_visit'] = str(datetime.now())
        request.session['visits'] = visits
    
    context_dict['visits'] = visits


    response = render(request,'rango/about.html', context_dict)

    print context_dict['visits']
    #return HttpResponse('Rango says: Here is the about page. <a href="/rango/">Index</a>')
    return response    

def search(request):
    result_list = []

    if request.method== 'POST':
        query = request.POST['query'].strip()

        if query:
            #run bing function to get the result list
            result_list = run_query(query)

    return render(request,'rango/search.html',{'result_list':result_list})