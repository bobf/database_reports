# frozen_string_literal: true

User.find_or_create_by!(email: 'user@example.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
end

User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.admin = true
end
