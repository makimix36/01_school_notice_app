class SorceryCore < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email,            null: false, index: { unique: true }
      t.string :crypted_password
      t.string :salt
      t.string :nickname,       null: false

      t.timestamps null: false
    end
  end
end

rails g model Notification user:references title:string body:text deadline:date period_type:integer:default=0 is_important:boolean:default=false is_submission:boolean:default=false is_document:boolean:default=false