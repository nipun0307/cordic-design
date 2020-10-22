#Sine Cosine

import math


def compute_sin_cos(flag,angle,count,sin,cos):
    if(count==32):
        if(flag==0):
            return sin,cos
        elif (flag==1):
            return cos,-sin
        else:
            return -sin,-cos
            
        
    else:
        shifted_sin = sin/math.pow(2,count)
        shifted_cos = cos/math.pow(2,count)
        if (angle<0):
            d=-1
        else:
            d=+1
        cos_next = cos - (d*shifted_sin)
        sin_next = sin + (d*shifted_cos)
        angle_next = angle - (d*math.atan(math.pow(2,-count)))
        count=count+1
        return compute_sin_cos(flag,angle_next,count,sin_next,cos_next)

def _main():
    deg_angle = float(input("Enter the angle in degrees: "))
    flag = 0
    while(deg_angle>=360):
        deg_angle-=360
    if (deg_angle>90):
        deg_angle-=90
        flag=1        ##Angle in 2nd quadrant
        if (deg_angle>90):
            deg_angle-=90
            flag = 2  ## Angle in 3rd quadrant
    angle = deg_angle/180*math.pi
    
    print(compute_sin_cos(flag,angle,0,0,0.6072529350088814))
 
    
if __name__ == '__main__':
    _main()
    
        
      
    
##init_cos = 0.6072529350088814
