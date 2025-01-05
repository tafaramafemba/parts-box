PlatformFee.delete_all
CommissionFee.delete_all

PlatformFee.find_or_create_by(percentage: 0.03)
CommissionFee.find_or_create_by(percentage: 0.05)