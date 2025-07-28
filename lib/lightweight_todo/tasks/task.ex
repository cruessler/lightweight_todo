defmodule LightweightTodo.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias LightweightTodo.Tasks.Task
  alias LightweightTodo.Accounts.User

  schema "tasks" do
    belongs_to :user, User
    belongs_to :parent, Task, foreign_key: :parent_id
    has_many :children, Task, foreign_key: :parent_id

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
    |> cast(attrs, [:title, :body, :status, :parent_id])
    |> validate_required([:title])
    |> assoc_constraint(:user)
    |> assoc_constraint(:parent)
  end

  def compare_by_status(a, b) do
    case {a.status, b.status} do
      {:created, _} ->
        true

      {:completed, :completed} ->
        true

      _ ->
        false
    end
  end
end
