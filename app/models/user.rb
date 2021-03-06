# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  premium    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
    validates :email, presence:{message:'has not been entered'},uniqueness:{message:'address must be unique'}

    has_many :submitted_urls,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: :ShortenedUrl

    has_many :visits,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: :Visit  
    
    has_many :visited_urls,
        ->{distinct},
        through: :visits,
        source: :shortened_url

    has_many :votes,
        primary_key: :id,
        foreign_key: :voter_id,
        class_name: :Vote
    
    has_many :voted_urls,
        through: :votes,
        source: :url
end
