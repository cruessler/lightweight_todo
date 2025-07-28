defmodule LightweightTodoWeb.TaskLive.Show do
  use LightweightTodoWeb, :live_view

  alias LightweightTodo.Tasks
  alias LightweightTodo.Tasks.Task

  defp list_sorted_sub_tasks(parent_task) do
    Tasks.list_sub_tasks(parent_task)
    |> Enum.sort(&Task.compare_by_status/2)
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    task = Tasks.get_task!(socket.assigns.current_user, id)

    {:ok,
     stream(
       socket,
       :sub_tasks,
       list_sorted_sub_tasks(task)
     )}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    task = Tasks.get_task!(socket.assigns.current_user, id)
    live_action = socket.assigns.live_action

    {:noreply,
     socket
     |> assign(:page_title, page_title(live_action))
     |> assign(:task, task)
     |> maybe_assign_sub_task(live_action, task)}
  end

  defp page_title(:show), do: "Show Task"
  defp page_title(:new), do: "Show Task – Add Subtask"
  defp page_title(:edit), do: "Edit Task"

  defp maybe_assign_sub_task(socket, :new, task) do
    socket
    |> assign(:sub_task, %Task{parent_id: task.id})
  end

  defp maybe_assign_sub_task(socket, _, _), do: socket
end
