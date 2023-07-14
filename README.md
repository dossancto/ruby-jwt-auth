## Run

- Install dependencies

```sh
$ bundle install
```

- Start postgres at docker-compose

```sh
$ docker compose up -d
```

- Create database

```sh
$ bundle exec db:create
```

- Run migrations

```sh
$ bundle exec db:migrate
```

- Config `.env` see `.env.example` for an example

- Build Tailwind file

```sh
$ npm run build:css
```

- Run server

```sh
$ bundle exec puma
```

see at localhost:9292/
