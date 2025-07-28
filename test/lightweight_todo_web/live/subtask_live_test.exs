defmodule LightweightTodoWeb.SubtaskLiveTest do
  use LightweightTodoWeb.ConnCase

  alias LightweightTodo.Accounts
  import Phoenix.LiveViewTest
  import LightweightTodo.AccountsFixtures
  import LightweightTodo.TasksFixtures

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

  describe "Show" do
    test "creates new subtask", %{conn: conn, task: task} do
      {:ok, show_live, html} = live(conn, ~p"/tasks/#{task}")

      assert html =~ "Show Task"

      assert show_live |> element("a", "New Subtask") |> render_click() =~
               "Show Task – Add Subtask"

      assert_patch(show_live, ~p"/tasks/#{task}/tasks/new")

      assert show_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#task-form", task: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/tasks/#{task}")

      # TODO:
      # Currently, a manual reload is required to make the new subtask show up.
      # Change that so the page updates automatically.
      {:ok, _show_live, html} = live(conn, ~p"/tasks/#{task}")

      assert html =~ @update_attrs.title
    end
  end
end
