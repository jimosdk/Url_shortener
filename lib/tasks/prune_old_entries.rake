namespace :prune_old_entries do
    desc "Prune stale shortened url entries"
    task prune_shortened_urls: :environment do
        puts "Pruning old shortened url's"
        ShortenedUrl.prune(1200)
    end
end