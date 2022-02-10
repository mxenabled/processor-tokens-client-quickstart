class User < ApplicationRecord
    validates :name, presence: true, length: {minimum: 3}
    validates :password, presence: true, length: {minimum: 10}
end
