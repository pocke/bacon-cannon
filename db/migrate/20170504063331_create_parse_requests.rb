class CreateParseRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :parmlinks do |t|
      t.string :uuid, null: false
      t.text :code, null: false

      t.timestamps
    end

    create_table :parse_results do |t|
      t.references :parmlink, null: false, index: true, foreign_key: {on_delete: :cascade, on_update: :cascade}
      t.text :ast, null: false
      t.string :parser, null: false
      t.json :meta, null: false

      t.timestamps
    end

    create_table :parse_result_errors do |t|
      t.references :parmlink, null: false, index: true, foreign_key: {on_delete: :cascade, on_update: :cascade}
      t.string :parser, null: false
      t.string :error_class, null: false
      t.string :error_message, null: false

      t.timestamps
    end
  end
end
