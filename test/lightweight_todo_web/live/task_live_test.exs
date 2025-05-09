defmodule LightweightTodoWeb.TaskLiveTest do
  use LightweightTodoWeb.ConnCase

  alias LightweightTodo.Accounts
  import Phoenix.LiveViewTest
  import LightweightTodo.AccountsFixtures
  import LightweightTodo.TasksFixtures

  @create_attrs %{title: "some title", body: "some body"}
  @update_attrs %{title: "some updated title", body: "some updated body"}
  @invalid_attrs %{title: nil, body: nil}

  setup %{conn: conn} do
    user = user_fixture()
    user_token = Accounts.generate_user_session_token(user)
    task = task_fixture(user)
    sub_task = sub_task_fixture(task)

    conn =
      conn
      |> Map.replace!(:secret_key_base, LightweightTodoWeb.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})
      |> put_session(:user_token, user_token)

    %{user: user, task: task, sub_task: sub_task, conn: conn}
  end

  describe "Index" do
    test "lists all tasks", %{conn: conn, task: task} do
      {:ok, _index_live, html} = live(conn, ~p"/tasks")

      assert html =~ "Listing Tasks"
      assert html =~ task.title
    end

    test "saves new task", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/tasks")

      assert index_live |> element("a", "New Task") |> render_click() =~
               "New Task"

      assert_patch(index_live, ~p"/tasks/new")

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#task-form", task: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/tasks")

      html = render(index_live)
      assert html =~ "Task created successfully"
      assert html =~ "some title"
    end

    test "updates task in listing", %{conn: conn, task: task} do
      {:ok, index_live, _html} = live(conn, ~p"/tasks")

      assert index_live |> element("#tasks-#{task.id} a", "Edit") |> render_click() =~
               "Edit Task"

      assert_patch(index_live, ~p"/tasks/#{task}/edit")

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#task-form", task: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/tasks")

      html = render(index_live)
      assert html =~ "Task updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes task in listing", %{conn: conn, task: task} do
      {:ok, index_live, _html} = live(conn, ~p"/tasks")

      assert index_live |> element("#tasks-#{task.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#tasks-#{task.id}")
    end

    test "marks task as completed and todo in listing", %{conn: conn, task: task} do
      {:ok, index_live, _html} = live(conn, ~p"/tasks")

      assert index_live
             |> element("#tasks-#{task.id} a[aria-label='Mark as completed']")
             |> render_click() =~
               "Mark as todo"

      assert index_live |> element("#tasks-#{task.id} a", "Mark as todo") |> render_click() =~
               "Mark as completed"
    end

    test "updates sort order when task is marked as completed and todo in listing", %{
      user: user,
      conn: conn,
      task: task
    } do
      second_task = task_fixture(user)

      {:ok, index_live, _html} = live(conn, ~p"/tasks")

      assert task.id < second_task.id

      index_live
      |> element("#tasks-#{second_task.id} + #tasks-#{task.id} a[aria-label='Mark as completed']")
      |> render_click()

      assert index_live
             |> element("#tasks-#{second_task.id} + #tasks-#{task.id}")
             |> render() =~
               "Mark as todo"

      assert index_live
             |> element("#tasks-#{second_task.id} + #tasks-#{task.id}")
             |> render() =~
               "completed"

      index_live
      |> element("#tasks-#{second_task.id} + #tasks-#{task.id} a", "Mark as todo")
      |> render_click()

      assert index_live
             |> element("#tasks-#{second_task.id} + #tasks-#{task.id}")
             |> render() =~
               "Mark as completed"

      assert index_live
             |> element("#tasks-#{second_task.id} + #tasks-#{task.id}")
             |> render() =~
               "created"
    end
  end

  describe "Show" do
    test "displays task and list of sub-tasks", %{conn: conn, task: task, sub_task: sub_task} do
      {:ok, _show_live, html} = live(conn, ~p"/tasks/#{task}")

      assert html =~ "Show Task"
      assert html =~ task.title
      assert html =~ sub_task.title
    end

    test "updates task within modal", %{conn: conn, task: task} do
      {:ok, show_live, _html} = live(conn, ~p"/tasks/#{task}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Task"

      assert_patch(show_live, ~p"/tasks/#{task}/show/edit")

      assert show_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#task-form", task: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/tasks/#{task}")

      html = render(show_live)
      assert html =~ "Task updated successfully"
      assert html =~ "some updated title"
    end
  end
end
