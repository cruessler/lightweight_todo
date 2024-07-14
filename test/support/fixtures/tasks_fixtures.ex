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

  @doc """
  Generate a task that has one sub-task.
  """
  def parent_task_fixture(%User{} = user, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        body: "some body",
        title: "some title"
      })

    {:ok, parent_task} =
      LightweightTodo.Tasks.create_task(user, attrs)

    sub_task_attrs =
      %{
        body: "sub-task body",
        title: "sub-task title",
        parent_id: parent_task.id
      }

    {:ok, sub_task} =
      LightweightTodo.Tasks.create_task(parent_task, sub_task_attrs)

    %{parent_task: parent_task, sub_task: sub_task}
  end
end
