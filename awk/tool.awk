#!/usr/bin/awk -f
{
	split($0, m, "method=");
	split(m[2], method, "&");
	split(method[1], name, " ");
	time=substr($NF, 2, 5);
	time=time+0;
	if (time >= 1) 
	{
		if (name[1] in req_method) {
			req_time[name[1]]+=time;
			req_method[name[1]]++;
		} else {
			req_method[name[1]]=1;
			req_time[name[1]]=time;
		}
	
		#print name[1]"\t"time;		
	}
} 
END {
	for (k in req_method) {
		print k"\t"req_time[k] / req_method[k]"\t"req_method[k];
	}
	
}
