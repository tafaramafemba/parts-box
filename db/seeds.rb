# makes_and_models = {
#   "Toyota" => ["Corolla", "Camry", "RAV4"],
#   "Honda" => ["Civic", "Accord", "CR-V"],
#   "Ford" => ["Focus", "Fusion", "Escape"]
# }

# makes_and_models.each do |make, models|
#   car_make = CarMake.create!(name: make)
#   models.each do |model|
#     car_make.car_models.create!(name: model)
#   end
# end

# db/seeds.rb
CarPart.create!(
  name: "Brake Pads",
  description: "Essential for safe stopping, brake pads provide friction to slow your car.",
  tools: "Wrench, socket set, car jack, lug wrench, gloves",
  labor_cost: 50.00
)

CarPart.create!(
  name: "Air Filter",
  description: "Filters air entering the engine to ensure efficient performance.",
  tools: "Screwdriver, pliers, gloves",
  labor_cost: 20.00
)

CarPart.create!(
  name: "Oil Filter",
  description: "Removes contaminants from engine oil for smoother operation.",
  tools: "Oil filter wrench, gloves, drain pan",
  labor_cost: 30.00
)
