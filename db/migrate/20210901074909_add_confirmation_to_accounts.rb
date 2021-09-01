class AddConfirmationToAccounts < ActiveRecord::Migration[6.1]
  def self.up
    change_table :accounts do |t|
      rename_column :accounts, :activation_digest, :confirmation_token
      rename_column :accounts, :activated_at, :confirmed_at

      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email
    end
  end

  def self.down
    rename_column :accounts, :confirmation_token, :activation_digest
    rename_column :accounts, :confirmed_at, :activated_at
    remove_column :accounts, :confirmation_sent_at
    remove_column :accounts, :unconfirmed_email
  end
end
