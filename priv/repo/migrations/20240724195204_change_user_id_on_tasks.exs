defmodule LightweightTodo.Repo.Migrations.ChangeUserIdOnTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      modify(:user_id, references(:users, on_delete: :delete_all),
        from: references(:users, on_delete: :delete_all),
        null: false
      )
    end
  end
end
