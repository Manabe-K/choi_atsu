class RenameUidToGithubUidInUsers < ActiveRecord::Migration[7.2]
  def change
    # uid -> github_uid のカラム名変更
    rename_column :users, :uid, :github_uid

    # github_token カラムの追加
    add_column :users, :github_token, :string

    # github_uid にユニークインデックスを追加 (すでにインデックスが存在しない場合のみ)
    unless index_exists?(:users, :github_uid)
      add_index :users, :github_uid, unique: true
    end
  end
end
