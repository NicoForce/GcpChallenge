#FROM ubuntu:latest
FROM python:3.6.1-alpine

#RUN apt-get update -y && \
#    apt-get install -y python3-pip

WORKDIR /app

RUN pip install flask

COPY app.py /app/app.py

#ENTRYPOINT [ "python"]

CMD [ "python", "app.py" ]