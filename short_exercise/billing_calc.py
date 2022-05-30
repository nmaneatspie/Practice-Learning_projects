"""
Simple programming exercise that involves calculating an individual bill to a customer.
Input is Call durations (in seconds). Provided is billing policy.
Data is read from file line by line

Billing Policy:
Call duration (s)      Charge ($/s)
1-500                  0.01
501-800                0.008
801+                   0.005
"""
filename = "bill.txt"

try:
    f = open(filename, "r")
except:
    print("Error opening file, does the file exist? Is it called {} ?".format(filename))
    quit()
    
#call billing cutoffs (tiers)
tier = (501, 801)
charge = (0.01, 0.008, 0.005)

tier1_base = ( tier[0] - 1 ) * charge[0]
tier2_base = tier1_base + (tier[1] - tier[0] - 1 ) * charge[1]

#take in values and store
data = []
try:
    for x in f:
        data.append(int(x))
except:
    print("Error retrieving data from file")
    quit()
    
#Process each individual call
costs = []
for time in data:
    if time < tier[0]:
        costs.append( time * charge[0] )
    elif time < tier[1] and time >= tier [0]:
        time_tier1 = time - tier[0] - 1
        time_tot = tier1_base + time_tier1 * charge[1]
        costs.append( time_tot )
    else:
        time_tier2 = time - tier[1] - 1
        time_tot = tier2_base + time_tier2 * charge[2]
        costs.append( time_tot )
        
#Sum total
total = 0
for bill in costs:
    total += bill
    
print(total)
