admin = User.find_or_create_by!(email: "admin@doopler.local") do |u|
  u.password = "doopler123"
  u.admin = true
end

puts "Admin: #{admin.email} / password: doopler123"
