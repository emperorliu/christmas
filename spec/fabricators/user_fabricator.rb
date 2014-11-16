Fabricator(:user) do
  username { Faker::Name.name }
  password { Faker::Internet.password }
end