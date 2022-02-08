FROM python:3.8-alpine3.13 AS base
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
RUN apk update && apk add --no-cache postgresql-dev gcc python3-dev musl-dev libffi-dev libxml2-dev libxslt-dev pcre-dev netcat-openbsd

FROM base AS builder
RUN apk --update add --no-cache openssh-client git nodejs npm zbar-dev zlib-dev jpeg-dev
WORKDIR /code
COPY ems2/ /code/
RUN pip install --user -r /code/requirements.txt
RUN npm cache verify && npm install && npm run build
RUN rm -R /code/node_modules

FROM base AS prod
COPY --from=builder /code /code
COPY --from=builder /root/.local /root/.local
WORKDIR /code