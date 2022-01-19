FROM python:3.9-alpine
WORKDIR /v2ray-mkcp
COPY . .
RUN pip install requests > /dev/null 2>&1 && python build.py
ENTRYPOINT python run.py