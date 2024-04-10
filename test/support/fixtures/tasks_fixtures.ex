defmodule LightweightTodo.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LightweightTodo.Tasks` context.
  """
  alias LightweightTodo.Accounts.User

  @doc """
  Generate a task.
  """
  def task_fixture(%User{} = user, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        body: "some body",
        title: "some title"
      })

    {:ok, task} =
      LightweightTodo.Tasks.create_task(user, attrs)

    task
  end
end
