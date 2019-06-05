# name: autolink
# about: Plugin to autolink #numbers in posts to the corresponding post in the topic
# version: 1.0.1
# authors: KC Maddever (kcereru)
# url: https://github.com/kcereru/autolink

AUTOLINK_PLUGIN_NAME ||= "autolink".freeze

enabled_site_setting :autolink_enabled

after_initialize do
  DiscourseEvent.on(:post_created) do |post|

    # if poll exists in post (checking for poll closing tag) ignore

    if post.raw.include? "[/poll]"
      next
    end

    # If post exists, replace with link, otherwise no changes
    # Ignore numbers followed by a square bracket, they may be links

    r = /#(\d+)(?=[^\d\]]|$)/
    post.raw.gsub!(r) { |m| m.gsub!($1, get_link(post, $1)) }

    post.save
  end
end


def specific_post(post_num, topic_id)
  Post.find_by("topic_id = :topic_id AND post_number = :post_number", topic_id: topic_id, post_number: post_num)
end

def get_link(post, post_num)
  if(specific_post(post_num, post.topic_id))
    return '[' + post_num + '](' + specific_post(post_num, post.topic_id).full_url + ')'
  else
    return post_num
  end
end
