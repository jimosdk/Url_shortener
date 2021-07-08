# == Schema Information
#
# Table name: tag_topics
#
#  id         :bigint           not null, primary key
#  topic      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tag_topics_on_topic  (topic) UNIQUE
#
class TagTopic < ApplicationRecord
    validates :topic,presence:true,uniqueness:true

    def popular_links
        res = TagTopic.joins(:urls).joins(urls: :visits).select("shortened_urls.long_url,COUNT(visits.shortened_url_id) AS num_clicks ").where("topic = ?" ,self.topic ).group("shortened_urls.long_url").
        order("COUNT(visits.shortened_url_id) DESC").limit(5)
        res.each_with_object({}){|r,h| h[r.long_url] = r.num_clicks}
    end

    has_many :taggings,
        primary_key: :id,
        foreign_key: :topic_id,
        class_name: :Tagging

    has_many :urls,
        ->{distinct},
        through: :taggings,
        source: :url
end
