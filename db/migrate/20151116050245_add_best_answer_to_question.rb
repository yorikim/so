class AddBestAnswerToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :best_answer_id, :integer, index: true, foreign_key: true
  end
end
