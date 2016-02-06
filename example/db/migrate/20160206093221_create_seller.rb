class CreateSeller < ActiveRecord::Migration
  def change
    create_table :sellers do |t|
      t.string :name
    end
  end
end
