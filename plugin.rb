# name: autolink
# about: Plugin to autolink #numbers in posts to the corresponding post in the topic
# version: 0.1.0
# authors: KC Maddever (kcereru)
# url: https://github.com/kcereru/autolink

AUTOLINK_PLUGIN_NAME ||= "autolink".freeze

enabled_site_setting :autolink_enabled

after_initialize do
  DiscourseEvent.on(:post_created) do |post|
    # as a first step, just change #postnumber to [#postnumber](posturl)
    #post.raw.gsub!(/#(\d*)/) { |post_num| '[#' + post_num + '](' + specific_post(post_num, post.topic_id).full_url + ')'}
    post.raw.gsub!(/#(\d*)/) { |post_num| '[#' + post_num + ']'}
    post.save
  end
end


def specific_post(post_num, topic_id)
  Post.find_by("topic_id = :topic_id AND post_number = :post_number", topic_id: topic_id, post_number: post_num)
end
