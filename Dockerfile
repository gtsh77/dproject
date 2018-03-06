FROM python:3.6

# Install node prereqs, nodejs and yarn
# Ref: https://deb.nodesource.com/setup_8.x
# Ref: https://yarnpkg.com/en/docs/install
RUN \
  apt-get update && \
  apt-get install -yqq apt-transport-https
RUN \
  echo "deb https://deb.nodesource.com/node_8.x jessie main" > /etc/apt/sources.list.d/nodesource.list && \
  wget -qO- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
  wget -qO- https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  apt-get update && \
  apt-get install -yqq nodejs yarn && \
  rm -rf /var/lib/apt/lists/*

#env
RUN mkdir /app
WORKDIR /app

#django
RUN pip install Django
RUN pip install djangorestframework

#create django project
RUN django-admin startproject dproject1

#new env
WORKDIR /app/dproject1

#create django app
RUN python manage.py startapp rest_api

#apply app files
COPY ./django/rest_api/models.py /app/dproject1/rest_api
COPY ./django/rest_api/serializers.py /app/dproject1/rest_api
COPY ./django/rest_api/urls.py /app/dproject1/rest_api
COPY ./django/rest_api/views.py /app/dproject1/rest_api

COPY ./django/settings.py /app/dproject1/dproject1
COPY ./django/urls.py /app/dproject1/dproject1

#migrate
RUN python manage.py makemigrations rest_api
RUN python manage.py sqlmigrate rest_api 0001
RUN python manage.py migrate

#copy fixtures
RUN mkdir rest_api/fixtures
COPY ./django/rest_api/fixtures/echoreply.json /app/dproject1/rest_api/fixtures

#apply fixture
RUN python manage.py loaddata echoreply.json

#add vue app
ADD frontend /app/dproject1/rest_api/frontend

#build front
WORKDIR /app/dproject1/rest_api/frontend
RUN npm install
RUN npm run build

WORKDIR /app/dproject1

#bind port
EXPOSE 8000:8000