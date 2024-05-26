FROM python:3.9

WORKDIR /usr/src/app

COPY . .

RUN pip install --upgrade pip

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 6000

CMD ["python", "./app.py"]
