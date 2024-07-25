defmodule LightweightTodo.Repo.Migrations.ChangeParentIdOnTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      modify(:parent_id, references(:tasks, on_delete: :nilify_all),
        from: references(:tasks, on_delete: :nothing)
      )
    end
  end
end
