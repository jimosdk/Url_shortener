# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint           not null, primary key
#  long_url   :string           not null
#  short_url  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_shortened_urls_on_short_url  (short_url) UNIQUE
#  index_shortened_urls_on_user_id    (user_id)
#
require 'securerandom'

class ShortenedUrl < ApplicationRecord
    validates :long_url,:user_id,presence:true
    validates :short_url,presence:true,uniqueness:true

    def self.random_code
        code = nil
        code = SecureRandom.urlsafe_base64(16) while ShortenedUrl.exists?(short_url:code) || code == nil
        code
    end

    def self.generate_short_url(user,long_url)
        code = random_code
        ShortenedUrl.create!(short_url:code,long_url:long_url,user_id:user.id)
    end

    belongs_to :submitter,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: :User
end
