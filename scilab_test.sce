
clear
 

// this function removes unwated rows containing spaces
function back = remove_space(r_1)
    count=1;
    for i=1:size(r_1,1)-1
        if ((r_1(i)=="") & (r_1(i+1)=="")) // if there are consecutive null cells, ignore them 
            // ignore
            
        else 
            temp(count)=r_1(i);
            count=count+1;
           
        end
    end
    
   
    back=temp;
    
    
   endfunction





// this concatinates the string array inot temp variable
function temp= concat_service(data)
    temp="";
    for i=1:size(data,1)
        temp=strcat([temp,data(i)],' ');
    end
    
endfunction











rep=unix_g("docker images");
flag=0;
counter=0;
for i=1:size(rep,1)
    [r_1, r_2] = strsplit(rep(i)," ")
    if flag==1 then
        counter=counter+1;
    end
    if  r_1(1) == "REPOSITORY" then
        flag=1;
    end
    c=1;
    for j=2:size(r_1,1)
        if r_1(j)=="" then
           
        else
             c=c+1
        end
        if c==3 then
            
            break
        end
    end
    
    
    h(i)=r_1(j);  // all the image ID in here with starting 2 index
    disp(string(counter)+" " +r_1(1)+"  "+r_1(j))
  
end  
endx=input("Image to optimize: ")
[r_1, r_2] = strsplit(rep(endx+1)," ")



rep1=unix_g("docker history "+r_1(1));
////-------------------


for i=2:size(rep1,1)
    [r_1, r_2] = strsplit(rep1(i)," ")
    there=0;
    for j=2:size(h,1)
        if h(j)== r_1(1) then
            there=1
            point=j
            break
        end
        
    end
    if there==0 then
        
        break
    end
    
end

[r_1, r_2] = strsplit(rep1(i-1)," ")
disp(r_1(1));


[r_1, r_2] = strsplit(rep(point)," ")  // get the image name

firstcommand="From "+r_1(1);
disp("From "+r_1(1));
p1=0

othercommand=[];
for k=2:i-2
    [r_1, r_2] = strsplit(rep1(k)," ")
    back=remove_space(r_1)
    
    
    //disp(back)
    
    flag=0;
    
    for j=2:size(back,1)
        if flag==1 then
            p1=j
            flag=0
        end
        if back(j)=="-c" then
            flag=1
        end
        
        
    end
    //disp(back(p1:size(back,1)-2))
    b= concat_service(back(p1:size(back,1)-2));
   // disp(b)
    othercommand(k)=strcat (["RUN",b],' ');
    
end
disp(othercommand)

fd = mopen('Dockerfile_temp','wt');
mputl(firstcommand,fd);

for k=1:size(othercommand,1)
    disp("####")
    disp(othercommand(size(othercommand,1)-k+1))
    mputl(othercommand(size(othercommand,1)-k+1),fd);
end


mclose(fd);

unix("go run test.go");  /// optimise from the test.go

xin=input("Enter the Image name : ","string")


re=unix_g("docker build -t "+xin+"  .");
disp(re)
