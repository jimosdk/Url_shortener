class Vote < ApplicationRecord
    validates :url_id,:voter_id,:score,presence: true
    validates :url_id,uniqueness:{scope: :voter_id,message:"already received vote from this user"}
    validate :self_vote
    
    def self.vote_url(user,url,score)
        Vote.create!(voter_id: user.id,url_id: url.id,score: score)
    end

    def self_vote
        errors.add(:base,"Voting on own submissions is not permitted") if own_submission?
    end

    belongs_to :voter,
        primary_key: :id,
        foreign_key: :voter_id,
        class_name: :User 
    
    belongs_to :url,
        primary_key: :id,
        foreign_key: :url_id,
        class_name: :ShortenedUrl

    private

    def own_submission?
        voter_id == ShortenedUrl.find(url_id).user_id
    end
end