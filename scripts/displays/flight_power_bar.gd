extends ProgressBar

#@onready var timer = $FlightTimer
#@onready var flight_charge_bar = $FlightCharge

var flight_charge = 0 : set = _set_charge

func _set_charge(new_charge):
	#var prev_charge = flight_charge
	value = new_charge 
	if new_charge >= 100:
		value = 100

#func init_flight_charge(_charge):
	#charge = 0
	#max_value = 100.0
	#min_value = 0
	#value = charge
	#flight_charge_bar.max_value = 100.0
	#flight_charge_bar.min_value = 0
	#flight_charge_bar.value = charge
	#print("init values: charge: " + str(charge) + " min: " + str(min_value) + " value: " + str(value) + " max_value: " + str(max_value))
