class ActsAsMarkableMigration < ActiveRecord::Migration
  def change
    create_table :marks do |t|
      t.references :marker, polymorphic: true, null: false, index: true
      t.references :markable, polymorphic: true, null: false, index: true
      t.string :mark

      t.timestamps null: false
    end
  end
end
