FROM python:3.10.13

WORKDIR /flask_709_2

COPY app.py .
COPY requirements.txt .
COPY query.py .

RUN pip install -r requirements.txt
CMD ["python", "-m", "flask", "run", "--host=0.0.0.0"]
