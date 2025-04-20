# frozen_string_literal: true

class User < Base
  attr_accessor :id, :first_name, :last_name, :organisation_id

  def organisation
    Organisation.all.find { |org| org.id == organisation_id }
  end

  def posts
    Post.all.find_all { |post| post.user_id == id }
  end
end
