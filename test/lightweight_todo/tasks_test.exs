defmodule LightweightTodo.TasksTest do
  use LightweightTodo.DataCase

  alias LightweightTodo.Tasks

  describe "tasks" do
    alias LightweightTodo.Tasks.Task

    import LightweightTodo.TasksFixtures
    import LightweightTodo.AccountsFixtures

    @invalid_attrs %{title: nil, body: nil}

    test "list_tasks/1 returns all tasks" do
      user = user_fixture()
      task = task_fixture(user)
      assert Tasks.list_tasks(user) == [task]
    end

    test "get_task!/2 returns the task with given id" do
      user = user_fixture()
      task = task_fixture(user)
      assert Tasks.get_task!(user, task.id) == task
    end

    test "create_task/2 with valid data creates a task" do
      user = user_fixture()

      valid_attrs = %{title: "some title", body: "some body"}

      assert {:ok, %Task{} = task} = Tasks.create_task(user, valid_attrs)
      assert task.title == "some title"
      assert task.body == "some body"
    end

    test "create_task/2 with empty body creates a task" do
      user = user_fixture()

      valid_attrs = %{title: "some title", body: ""}

      assert {:ok, %Task{} = task} = Tasks.create_task(user, valid_attrs)
      assert task.title == "some title"
      assert task.body == ""
    end

    test "create_task/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(user, @invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      user = user_fixture()
      task = task_fixture(user)
      update_attrs = %{title: "some updated title", body: "some updated body"}

      assert {:ok, %Task{} = task} = Tasks.update_task(task, update_attrs)
      assert task.title == "some updated title"
      assert task.body == "some updated body"
    end

    test "update_task/2 with invalid data returns error changeset" do
      user = user_fixture()
      task = task_fixture(user)
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(user, task.id)
    end

    test "delete_task/1 deletes the task" do
      user = user_fixture()
      task = task_fixture(user)
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(user, task.id) end
    end

    test "change_task/1 returns a task changeset" do
      user = user_fixture()
      task = task_fixture(user)
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end

    test "sorting with compare_by_status/2 returns open tasks first" do
      user = user_fixture()
      first_task = task_fixture(user, %{status: :completed})
      second_task = task_fixture(user, %{status: :created})
      third_task = task_fixture(user, %{status: :created})

      assert [%{status: :created}, %{status: :created}, %{status: :completed}] =
               [first_task, second_task, third_task] |> Enum.sort(&Task.compare_by_status/2)
    end
  end
end
