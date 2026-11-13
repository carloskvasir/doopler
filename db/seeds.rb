admin_password = ENV["ADMIN_PASSWORD"].presence || (raise "ADMIN_PASSWORD is required in production" if Rails.env.production?)
generated_password = SecureRandom.base58(16) if admin_password.nil?

admin = User.find_or_create_by!(email: "admin@doopler.local") do |u|
  u.password = admin_password || generated_password
  u.admin = true
end

puts "Admin: #{admin.email}"
puts "Generated password: #{generated_password}" if generated_password

expiring = Post.create!(user: admin, content: "Este post está quase expirando — só restam 2 minutos.")
expiring.update_column(:expires_at, 2.minutes.from_now)

Post.create!(user: admin, content: "Post normal — expira em 2 horas a partir de agora.")

puts "Posts de seed criados."
