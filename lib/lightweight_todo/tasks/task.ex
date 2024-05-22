defmodule LightweightTodo.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias LightweightTodo.Accounts.User

  schema "tasks" do
    belongs_to :user, User

    field :title, :string
    field :body, :string

    field :status, Ecto.Enum, values: [:created, :completed], default: :created

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :body, :status])
    |> validate_required([:title, :body])
    |> assoc_constraint(:user)
  end
end
