import math

k=0.6072529350088814 #pre-computed constant (multiplying cos value for 32 iterations)

def rotate(point,angle,count):
    x,y=point
    
    if(count==32):
        x=k*x
        y=k*y
        return x,y
    else:
        if(angle>=0):
            d=+1
        else:
            d=-1
            
        x_new=(x-(d*y*math.pow(2,-count)))
        y_new=(y+(d*x*math.pow(2,-count)))
        point_new=(x_new,y_new)
        angle_new=angle-(d*math.atan(math.pow(2,-count)))
        count=count+1
        
        return rotate(point_new,angle_new,count)
        
def _main():
    
    x=float(input("enter the x coordinate: "))
    y=float(input("enter the y coordinate: "))
    deg_angle = float(input("Enter the angle in degrees: "))
    flag = 0
    while(deg_angle>=360):
        deg_angle-=360
    if (deg_angle>90):
        deg_angle-=90
        flag=1        ##Angle in 2nd quadrant
        if (deg_angle>90):
            deg_angle-=90
            flag = 2  ## Angle in 4th quadrant
    angle = (deg_angle/180)*math.pi
    
    point=(x,y)
    print(rotate(point,angle,0))
    
 
    
if __name__ == '__main__':
    _main()
