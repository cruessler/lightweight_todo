defmodule LightweightTodo.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias LightweightTodo.Repo

  alias LightweightTodo.Tasks.Task
  alias LightweightTodo.Accounts.User

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_root_tasks(user)
      [%Task{}, ...]

  """
  def list_root_tasks(%User{} = user) do
    user
    |> Ecto.assoc(:tasks)
    |> where([t], is_nil(t.parent_id))
    |> order_by(desc: :id)
    |> Repo.all()
  end

  @doc """
  Returns the list of tasks that belong to a given parent task.

  ## Examples

      iex> list_sub_tasks(parent_task)
      [%Task{}, ...]

  """
  def list_sub_tasks(%Task{} = parent_task) do
    parent_task
    |> Ecto.assoc(:children)
    |> order_by(desc: :id)
    |> Repo.all()
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(user, 123)
      %Task{}

      iex> get_task!(user, 456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(%User{} = user, id) do
    user
    |> Ecto.assoc(:tasks)
    |> Repo.get!(id)
  end

  def create_task(assoc, attrs \\ %{})

  @doc """
  Creates a task or sub-task.

  ## Examples

      iex> create_task(user, %{field: value})
      {:ok, %Task{}}

      iex> create_task(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

      iex> create_task(parent_task, %{field: value})
      {:ok, %Task{}}

      iex> create_task(parent_task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(%User{} = user, attrs) do
    user
    |> Ecto.build_assoc(:tasks)
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def create_task(%Task{} = parent_task, attrs) do
    parent_task
    |> Ecto.build_assoc(:children)
    |> Task.changeset(attrs)
    |> Ecto.Changeset.change(%{user_id: parent_task.user_id})
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end
end
