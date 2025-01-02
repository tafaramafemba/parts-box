# Clear existing delivery slots
DeliverySlot.destroy_all

# Create delivery slots
DeliverySlot.create!([
  { time: '09:00', cutoff: 1 },
  { time: '13:00', cutoff: 1 },
  { time: '15:00', cutoff: 1 }
])