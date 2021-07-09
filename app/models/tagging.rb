# == Schema Information
#
# Table name: taggings
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  topic_id   :integer          not null
#  url_id     :integer          not null
#
# Indexes
#
#  index_taggings_on_topic_id  (topic_id)
#  index_taggings_on_url_id    (url_id)
#
class Tagging < ApplicationRecord
    validates :url_id,:topic_id,presence:true

    def self.tag(url,topic)
        create!(url_id:url.id,topic_id: topic.id)
    end

    belongs_to :tag_topic,
        primary_key: :id,
        foreign_key: :topic_id,
        class_name: :TagTopic

    belongs_to :url,
        primary_key: :id,
        foreign_key: :url_id,
        class_name: :ShortenedUrl 
end
