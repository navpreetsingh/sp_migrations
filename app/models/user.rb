class User < ActiveRecord::Base
  belongs_to :group
  belongs_to :role
  belongs_to :user_status
end
