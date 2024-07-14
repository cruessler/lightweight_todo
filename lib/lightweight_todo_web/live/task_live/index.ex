defmodule LightweightTodoWeb.TaskLive.Index do
  use LightweightTodoWeb, :live_view

  alias LightweightTodo.Tasks
  alias LightweightTodo.Tasks.Task

  defp list_sorted_tasks(user) do
    Tasks.list_root_tasks(user)
    |> Enum.sort(&Task.compare_by_status/2)
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     stream(
       socket,
       :tasks,
       list_sorted_tasks(socket.assigns.current_user)
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:task, Tasks.get_task!(socket.assigns.current_user, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Task")
    |> assign(:task, %Task{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tasks")
    |> assign(:task, nil)
  end

  @impl true
  def handle_info({LightweightTodoWeb.TaskLive.FormComponent, {:created, task}}, socket) do
    {:noreply, stream_insert(socket, :tasks, task, at: 0)}
  end

  @impl true
  def handle_info({LightweightTodoWeb.TaskLive.FormComponent, {:saved, task}}, socket) do
    {:noreply, stream_insert(socket, :tasks, task)}
  end

  @impl true
  def handle_event("mark_as_completed", %{"id" => id}, socket) do
    task = Tasks.get_task!(socket.assigns.current_user, id)
    {:ok, _updated_task} = Tasks.update_task(task, %{status: "completed"})

    {:noreply,
     stream(socket, :tasks, list_sorted_tasks(socket.assigns.current_user), reset: true)}
  end

  @impl true
  def handle_event("mark_as_todo", %{"id" => id}, socket) do
    task = Tasks.get_task!(socket.assigns.current_user, id)
    {:ok, _updated_task} = Tasks.update_task(task, %{status: "created"})

    {:noreply,
     stream(socket, :tasks, list_sorted_tasks(socket.assigns.current_user), reset: true)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    task = Tasks.get_task!(socket.assigns.current_user, id)
    {:ok, _} = Tasks.delete_task(task)

    {:noreply, stream_delete(socket, :tasks, task)}
  end
end
