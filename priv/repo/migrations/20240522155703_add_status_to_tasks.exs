defmodule LightweightTodo.Repo.Migrations.AddStatusToTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :status, :string
    end
  end
end
