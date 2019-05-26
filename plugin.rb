# name: autolink
# about: Plugin to autolink #numbers in posts to the corresponding post in the topic
# version: 1.0.0
# authors: KC Maddever (kcereru)
# url: https://github.com/kcereru/autolink

AUTOLINK_PLUGIN_NAME ||= "autolink".freeze

enabled_site_setting :autolink_enabled

after_initialize do
  DiscourseEvent.on(:post_created) do |post|

    # If post exists, replace with link, otherwise no changes

    post.raw.gsub!(/#(\d*)/) { |post_num|
      if(specific_post(post_num.tr('#', ''), post.topic_id))
        '[#' + post_num.tr('#', '') + '](' + specific_post(post_num.tr('#', ''), post.topic_id).full_url + ')'
      else
        post_num
      end
    }

    post.save
  end
end


def specific_post(post_num, topic_id)
  Post.find_by("topic_id = :topic_id AND post_number = :post_number", topic_id: topic_id, post_number: post_num)
end
