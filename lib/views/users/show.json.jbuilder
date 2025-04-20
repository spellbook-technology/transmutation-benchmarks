# frozen_string_literal: true

json.call(user, :id, :first_name)
json.full_name "#{user.first_name} #{user.last_name}"
