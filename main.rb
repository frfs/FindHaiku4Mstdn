require 'bundler/setup'
require 'mastodon'
require 'ikku'
require 'sanitize'

debug = true
unfollow_str = "俳句検出を停止してください"

stream = Mastodon::Streaming::Client.new(
  base_url: "https://" + ENV["BASE_URL"],
  bearer_token: ENV["ACCESS_TOKEN"])

rest = Mastodon::REST::Client.new(
  base_url: "https://" + ENV["BASE_URL"],
  bearer_token: ENV["ACCESS_TOKEN"])

reviewer = Ikku::Reviewer.new

reviewer_id = rest.verify_credentials().id

c = 0
stream.user() do |toot|
  begin
    if toot.kind_of?(Mastodon::Status) then
      content = Sanitize.clean(toot.content)
      unfollow_request = false
      toot.mentions.each do |mention|
        if mention.id == reviewer_id
          if !content.index(unfollow_str).nil?
            unfollow_request = true
            relationships = rest.relationships([toot.account.id])
            relationships.each do |relationship|
              if relationship.following?
                rest.unfollow(toot.account.id)
                p "unfollow"
              end
            end
          end
        end
      end
      if !unfollow_request && (toot.visibility == "public" || toot.visibility == "unlisted") then
        if toot.in_reply_to_id.nil? && toot.attributes["reblog"].nil? then
          p "@#{toot.account.acct}: #{content}" if debug
          haiku = reviewer.find(content)
          if haiku then
            postcontent = "『#{haiku.phrases[0].join("")}#{haiku.phrases[1].join("")}#{haiku.phrases[2].join("")}』"
            p "俳句検知: #{postcontent}" if debug
            p "tags: #{toot.attributes["tags"]}" if debug
            if toot.attributes["tags"].map{|t| t["name"]}.include?("theboss_tech") then
              postcontent += ' #theboss_tech'
            end
            if toot.attributes["spoiler_text"].empty? then
              rest.create_status("@#{toot.account.acct} 俳句を発見致しました！\n" + postcontent, in_reply_to_id: toot.id)
            else
              rest.create_status("@#{toot.account.acct}\n" + postcontent, in_reply_to_id: toot.id, spoiler_text: "俳句を発見致しました！")
            end
            p "post!" if debug
          elsif debug
            p "俳句なし"
          end
        elsif debug
          p "BT or reply"
        end
      elsif debug
        p "private toot"
      end
    elsif toot.kind_of?(Mastodon::Notification) then
      p "#{toot.type} by #{toot.account.id}" if debug
      rest.follow(toot.account.id) if toot.type == "follow"
    end
  rescue => e
    puts e
    c += 1
    if t < 3
      p "retry"
      retry
    else
      p "skip"
      next
    end
  end
end
