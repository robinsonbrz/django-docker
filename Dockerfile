# syntax=docker/dockerfile:1
FROM python:3

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# create directory for the app user
RUN mkdir -p /home/app

# create the app user
RUN groupadd app && useradd app -g app 

# create the appropriate directories
ENV HOME=/home/app/
ENV APP_HOME=/home/app/src
RUN mkdir $APP_HOME
RUN mkdir $APP_HOME/media
#RUN mkdir $APP_HOME/staticfiles
#RUN mkdir $APP_HOME/mediafiles
WORKDIR $HOME


COPY ./requirements.txt .
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# copy entrypoint-prod.sh
COPY ./src/entrypoint.sh $APP_HOME

# chown all the files to the app user
RUN chown -R app:app $HOME

RUN chmod +x $APP_HOME/entrypoint.sh


# COPY . /code/

USER app

ENTRYPOINT ["/home/app/src/entrypoint.sh"]