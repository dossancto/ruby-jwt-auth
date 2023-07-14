## Run

- Install dependencies

```sh
$ bundle install
```

- Start postgres at docker-compose

```sh
$ docker compose up -d
```

- Config `.env` see `.env.example` for an example

- Run server

```sh
$ bundle exec puma
```

see at localhost:9292/