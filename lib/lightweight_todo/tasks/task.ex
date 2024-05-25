defmodule LightweightTodo.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias LightweightTodo.Accounts.User

  schema "tasks" do
    belongs_to :user, User

    field :title, :string
    # Ecto converts an empty string to `nil`, but we want to keep the empty
    # string.
    field :body, :string, default: ""

    field :status, Ecto.Enum, values: [:created, :completed], default: :created

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :body, :status])
    |> validate_required([:title])
    |> assoc_constraint(:user)
  end
end
