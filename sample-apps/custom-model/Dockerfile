# syntax=docker/dockerfile:1
FROM nvcr.io/nvidia/tensorflow:22.02-tf2-py3
WORKDIR /app
ENV AWS_DEFAULT_REGION=us-west-2

COPY code/ ./

RUN pip3 install --upgrade pip wheel \
&& pip3 install -r requirements.txt

CMD ["python3","keras-model.py"]