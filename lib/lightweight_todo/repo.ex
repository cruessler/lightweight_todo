defmodule LightweightTodo.Repo do
  use Ecto.Repo,
    otp_app: :lightweight_todo,
    adapter: Ecto.Adapters.Postgres
end
