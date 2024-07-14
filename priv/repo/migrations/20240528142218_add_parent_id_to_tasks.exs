defmodule LightweightTodo.Repo.Migrations.AddParentIdToTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :parent_id, references(:tasks), null: true
    end

    create index(:tasks, :parent_id)
  end
end
