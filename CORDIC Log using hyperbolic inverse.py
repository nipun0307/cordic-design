import math
import numpy as np

#Code to generate LUT for arctanh()
"""lut=[]
import numpy as np
i=-5

while(i<26):
    a=[0,0]
    if (i<=0):
        a[0]=1-2**(i-2)
        a[1]=np.arctanh(1-2**(i-2))
    else:
        a[0]=2**(-i)
        a[1]=np.arctanh(2**(-i))
    i+=1
    lut.append(a)

print(lut)"""

lut=[[0.9921875, 2.770631772579213], [0.984375, 2.4220935432292956], \
 [0.96875, 2.0715673631957663], [0.9375, 1.7169936022425731], [0.875, 1.354025100551105],\
 [0.75, 0.9729550745276566], [0.5, 0.5493061443340549], [0.25, 0.2554128118829953], \
 [0.125, 0.12565721414045306], [0.0625, 0.06258157147700301], [0.03125, 0.03126017849066699],\
 [0.015625, 0.01562627175205221], [0.0078125, 0.007812658951540421], \
 [0.00390625, 0.003906269868396826], [0.001953125, 0.0019531274835325498], \
 [0.0009765625, 0.000976562810441036], [0.00048828125, 0.0004882812888051128], \
 [0.000244140625, 0.0002441406298506386], [0.0001220703125, 0.00012207031310632982],
 [6.103515625e-05, 6.103515632579122e-05], [3.0517578125e-05, 3.05175781344739e-05], \
 [1.52587890625e-05, 1.5258789063684237e-05], [7.62939453125e-06, 7.62939453139803e-06], \
 [3.814697265625e-06, 3.8146972656435034e-06], [1.9073486328125e-06, 1.907348632814813e-06], \
 [9.5367431640625e-07, 9.53674316406539e-07], [4.76837158203125e-07, 4.768371582031611e-07], \
 [2.384185791015625e-07, 2.38418579101567e-07], [1.1920928955078125e-07, 1.192092895507818e-07], \
 [5.960464477539063e-08, 5.960464477539069e-08], [2.9802322387695312e-08, 2.980232238769532e-08]]


def hyperbolic_atan(x,y,angle,count):
    if (x*y>=0):
        di=-1
    else:
        di=1
    if (count==26):  #if count=x, i will have x+5 values in my LUT, my LUT size is 31. 
        
        return angle
    else:
        if (count>0):
            x_new=x+(y*di*lut[count+5][0])
            y_new=y+(x*di*lut[count+5][0])
            angle+=-di*(lut[count+5][1])


        elif (count<=0):
            x_new=x+(y*di*lut[count+5][0])
            y_new=y+(x*di*lut[count+5][0])
            angle+=-di*(lut[count+5][1])
                
    
        
        count=count+1
        return hyperbolic_atan(x_new, y_new, angle, count)
        


m=float(input("Enter value whose log has to be calculated "))
print("The CORDIC value is" ,2*hyperbolic_atan(m+1, m-1,0, -5)) #the initial value of count determines
                                                            #the allowed values for 'm'->input
                                                            #lower 'm' => better range of input.

#comparing:
print("The actual value of logarithm is: ",np.log(m))
        
        
    
