# Product Tracker

An application that tracks pricing information for products. Product price
updates are fetched from an external API and persisted in a local database.

## Installation

```shell
> mix deps.get
> mix ecto.create
> mix ecto.migrate
```

*Note: PostgreSQL is required. Visit [https://www.postgresql.org](https://www.postgresql.org) for more info*

## Run the tests

```shell
> MIX_ENV=test mix ecto.create
> MIX_ENV=test mix ecto.migrate
> mix test
```

## Run the app

```shell
> mix run --no-halt
```
or
```shell
> iex -S mix
> ProductTracker.update_records # optional; will update automatically
```
