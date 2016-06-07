FROM debian:jessie
MAINTAINER igor.katson@gmail.com

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y build-essential python-dev python-psycopg2 git subversion mercurial libffi-dev libssl-dev python-svn libpcre3 libpcre3-dev python-ldap netcat

# Since Reviewboard 2.5 it has a dependency for Pillow.
# Since Pillow 3.0.0 installation fails if there is no libjpeg library [RFC: Require libjpeg and zlib by default](https://github.com/python-pillow/Pillow/issues/1412)
RUN apt-get install -y libtiff5-dev libjpeg-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev python-tk

# install the most up to date pip/setuptools python package management tools for python 2.7
RUN python -c "exec('try: from urllib2 import urlopen \nexcept: from urllib.request import urlopen');f=urlopen('https://bootstrap.pypa.io/get-pip.py').read();exec(f)"

RUN pip install -U reviewboard==2.5.6.1

RUN pip install -U uwsgi

ADD start.sh /start.sh
ADD uwsgi.ini /uwsgi.ini
ADD shell.sh /shell.sh

RUN chmod +x start.sh shell.sh

VOLUME ["/.ssh", "/media/"]

EXPOSE 8000

CMD /start.sh
