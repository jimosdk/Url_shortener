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