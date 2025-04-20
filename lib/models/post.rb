# frozen_string_literal: true

class Post < Base
  attr_accessor :id, :title, :body, :user_id

  def all
    @all ||= [
      Post.new(id: 1, title: 'John', body: 'Doe'),
      Post.new(id: 2, title: 'Jane', body: 'Smith'),
      Post.new(id: 3, title: 'Alice', body: 'Johnson')
    ]
  end
end
