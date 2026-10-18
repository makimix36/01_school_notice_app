class UpdateActiveStorageAttachmentNameToFile < ActiveRecord::Migration[7.1]
  # デプロイ（マイグレーション実行）時に行われる処理
  def up
    ActiveStorage::Attachment.where(record_type: 'Notification', name: 'file').update_all(name: 'files')
  end

  # もし元の状態に戻したくなった場合（ロールバック）の処理
  def down
    ActiveStorage::Attachment.where(record_type: 'Notification', name: 'files').update_all(name: 'file')
  end
end
