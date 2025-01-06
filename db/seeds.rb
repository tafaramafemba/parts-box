PlatformFee.delete_all
CommissionFee.delete_all
CategoryShippingFee.delete_all

PlatformFee.find_or_create_by(percentage: 0.00)
CommissionFee.find_or_create_by(percentage: 0.12)

categories = {
  'Engine Components' => 10.0,
  'Transmission & Drivetrain' => 12.0,
  'Suspension & Steering' => 8.0,
  'Braking System' => 7.0,
  'Electrical & Lighting' => 5.0,
  'Exhaust System' => 9.0,
  'Cooling System' => 11.0,
  'Fuel System' => 6.0,
  'Interior Parts' => 4.0,
  'Exterior Parts' => 6.0,
  'Body Parts' => 15.0,
  'Wheels & Tires' => 14.0,
  'Heating, Ventilation & Air Conditioning (HVAC)' => 13.0,
  'Accessories' => 3.0,
  'Performance Parts' => 20.0
}

categories.each do |category, fee|
  CategoryShippingFee.find_or_create_by(category: category, fee: fee)
end