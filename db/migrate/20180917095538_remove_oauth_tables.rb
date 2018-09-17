class RemoveOauthTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :oauth_access_grants if table_exists? :oauth_access_grants
    drop_table :oauth_access_tokens if table_exists? :oauth_access_tokens
    drop_table :oauth_applications if table_exists? :oauth_applications

  end
end
