class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :voteable, polymorphic: true

  validates :value, presence: true

  def change_value(op_value)
    self.value = (self.value + op_value) <=> 0
  end
end
