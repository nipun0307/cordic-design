list_angles = [1.107148,0.785398,0.463647,0.244978,0.124354,0.06241881,
               0.0312398,0.0156237,0.0078123,0.0039062301,0.00195312,
               0.0009765622,0.0004882812,0.0002441406,0.0001220703,
               0.0000610352,0.0000305176,0.0000152588,0.0000076294,0.0000038147,0.0000019073]
# 9.53674316e-7,4.76837158e-7
# list_angles2 = [45,26.5650,14.036,7.125,3.5763,1.7899,0.89517,0.447614,0.223810,0.111905,0.055952]
# list_angles3 = [0.3927,0.2318,0.1225,0.0622,0.0312,0.0156,0.0078,0.0039,0.002,0.001,0.0005]
import numpy as np
max_count=len(list_angles)

import math

def compute_angle(x,y,sum_of_angles,count,tan):
    rotation_direction = -1 if (y>0) else 1
    if(count==max_count):
        #print("value of y is: ",y)
        return sum_of_angles
    else:
        #transforming current x,y:
        x_transformed=x - y*tan*rotation_direction
        y_transformed=y + x*tan*rotation_direction
        tan_new=tan/2
        #statements for the next iteration:
        sum_of_angles += (-1)*rotation_direction*(np.arctan(2**(-count+1)))
        count=count+1
        return compute_angle(x_transformed,y_transformed,sum_of_angles,count,tan_new)

x=float(input("enter the x coordinate: "))
y=float(input("enter the y coordinate: "))
angle=compute_angle(x,y,0,0,2)
#print(angle)

#printing angle in degrees, not implemented in the processor:
print("\nAngle in radians: ",angle)

print("Expected angle is: ", math.atan(y/x))
