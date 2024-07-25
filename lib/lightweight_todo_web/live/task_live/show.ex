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
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:task, Tasks.get_task!(socket.assigns.current_user, id))}
  end

  defp page_title(:show), do: "Show Task"
  defp page_title(:edit), do: "Edit Task"
end
