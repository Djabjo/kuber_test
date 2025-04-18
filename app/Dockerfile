FROM python:3.12

WORKDIR /app

RUN apt-get update && apt-get install -y libpq-dev gcc
RUN /usr/local/bin/python -m pip install --upgrade pip

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt --root-user-action=ignore

COPY . .

CMD ["python", "Bot.py"]
