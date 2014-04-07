"""
Django settings for mysite project.

For more information on this file, see
https://docs.djangoproject.com/en/1.6/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.6/ref/settings/
"""

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
import os
BASE_DIR = os.path.dirname(os.path.dirname(__file__))


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.6/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'l1xo$2t2+dv1_2l=x6x1ofih!9h7h*112(d8*q8fz1z($h(1tr'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

TEMPLATE_DEBUG = True

ALLOWED_HOSTS = [
    '.amazonaws.com',
    '.amazonaws.com.',
    'ec2-54-212-169-137.us-west-2.compute.amazonaws.com',
]


# Application definition

INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'twython_django_oauth',
    'polls',
    'storages',
)

MIDDLEWARE_CLASSES = (
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
)

ROOT_URLCONF = 'mysite.urls'

WSGI_APPLICATION = 'mysite.wsgi.application'


# Database
# https://docs.djangoproject.com/en/1.6/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}

# Internationalization
# https://docs.djangoproject.com/en/1.6/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.6/howto/static-files/

STATIC_ROOT = '/home/ec2-user/srv/mysite_static/'
STATIC_URL = '/static/'

#AWS_ACCESS_KEY_ID = os.environ['AWS_ACCESS_KEY_ID']
#AWS_SECRET_ACCESS_KEY = os.environ['AWS_SECRET_ACCESS_KEY']

AWS_ACCESS_KEY_ID = 'AKIAJLO3IXQXZFB2YZKQ'
AWS_SECRET_ACCESS_KEY = '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'
AWS_STORAGE_BUCKET_NAME = 'django-app-skullcandy-mysite'
STATICFILES_STORAGE = 'storages.backends.s3boto.S3BotoStorage'

STATIC_URL = 'http://s3.amazonaws.com/%s' % AWS_STORAGE_BUCKET_NAME + '/'

TWITTER_KEY = 'ePgF72q92wF5co7c0hRToQ'
TWITTER_SECRET = 'ycTbFjdm9R8LR9tQZr5DkRTjPQWJJZ1N0rg6PLw'

LOGIN_URL='/twitter/login'
LOGOUT_URL='/twitter/logout'
LOGIN_REDIRECT_URL='/'
LOGOUT_REDIRECT_URL='/'
