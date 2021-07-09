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
    validate :no_spamming,:nonpremium_max

    def self.random_code
        code = nil
        code = SecureRandom.urlsafe_base64(16) while ShortenedUrl.exists?(short_url:code) || code == nil
        code
    end

    def self.generate_short_url(user,long_url)
        code = random_code
        ShortenedUrl.create!(short_url:code,long_url:long_url,user_id:user.id)
    end

    def self.prune(n)
        ShortenedUrl.joins(:submitter).where("shortened_urls.created_at < ? AND users.premium = ? AND shortened_urls.id NOT IN (?)",
            Time.now - n.minutes,false,
            ShortenedUrl
            .select("shortened_urls.id")
            .joins(:visits)
            .where("visits.created_at > ?",
            Time.now - n.minutes)).destroy_all

    end

    def num_clicks
        visits.count
    end

    #with distinct_ified visitors

    def num_uniques
        visitors.count
    end

    def num_recent_uniques
        visitors.where(visits: {created_at: (Time.now - 10.minutes)..Time.now}).count
    end

    def no_spamming
        errors.add(:base,message: "Reached limit of 5 submissions per minute") if count_recent_submissions >= 5
    end

    def nonpremium_max
        errors.add(:base,message: "Reached limit of 5 submissions for non premium users") if count_submissions >= 5 && User.find(user_id).premium == false
    end

    def self.top 

    end

    def self.hot 
        
    end

    #without distinct-ified visitors
    # def num_uniques
    #     visits.select(:user_id).distinct.count
    # end

    # def num_recent_uniques
    #     visits.select("visits.user_id").distinct.where(visits: {created_at: (Time.now - 10.minutes)..Time.now}).count  
    # end

    belongs_to :submitter,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: :User

    has_many :visits,
        primary_key: :id,
        foreign_key: :shortened_url_id,
        class_name: :Visit,
        dependent: :destroy

    has_many :visitors,
        ->{distinct},
        through: :visits,
        source: :user

    has_many :taggings,
        primary_key: :id,
        foreign_key: :url_id,
        class_name:  :Tagging,
        dependent: :destroy

    has_many :tag_topics,
        ->{distinct},
        through: :taggings,
        source: :tag_topic

    has_many :votes,
        primary_key: :id,
        foreign_key: :url_id,
        class_name: :Vote,
        dependent: :destroy

    has_many :voters,
        through: :votes,
        source: :voter

    private

    def count_recent_submissions
        ShortenedUrl.where("user_id = ? AND created_at BETWEEN ? AND ?",user_id,Time.now - 5.minutes,Time.now).count
    end

    def count_submissions
        ShortenedUrl.where("user_id = ?",user_id).count
    end
end
