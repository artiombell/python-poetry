FROM python:3.11.1-slim

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

RUN apt-get update 
# dependencies for building Python packages
RUN apt-get install -y build-essential 
# psycopg2 dependencies
RUN apt-get install -y libpq-dev 
# Additional dependencies
RUN apt-get install -y telnet  
# youtube processor dependency
RUN apt-get install -y ffmpeg 
# cleaning up unused files
RUN apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false 


RUN rm -rf /var/lib/apt/lists/*

RUN pip3 install poetry
