Fabricator(:idea) do
  recipient { Faker::Lorem.word }
  price { Faker::Commerce.price }
  description { Faker::Lorem.paragraph(3) }

end