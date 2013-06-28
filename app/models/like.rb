class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :likeable, polymorphic: true, touch: true
end
