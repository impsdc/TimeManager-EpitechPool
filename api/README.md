# Launch project

Start Postgres db
`
docker run --name postgres \
-e POSTGRES_PASSWORD=postgres \
-p 5432:5432 -d --rm postgres

`
mix ecto.setup
`


try : http://localhost:4000/api/users
