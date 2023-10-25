FROM public.ecr.aws/panorama/panorama-application:1.2.0-py3.8
WORKDIR /panorama
COPY . .
RUN python3 -m pip install --no-cache-dir --upgrade pip && \
    python3 -m pip install --no-cache-dir -r requirements.txt
