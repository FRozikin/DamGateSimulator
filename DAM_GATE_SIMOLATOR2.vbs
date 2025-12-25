'PROGRAM : DAM GATE SIMULATION
'MAPPING REGISTER 4XXXX
'40001	'CURPOS MM		
'40002	'Command 		(0: noCommand, 1:Reset, 2:Stop, 3:Open, 4:Close, 5:ESD)
'40003	'MINPOS MM 
'40004	'MAXPOS MM
'40005	'SPAN/STEP MM
'40006	'L/R STATUS		(0: ERROR, 1:LOCAL, 2:REMOTE)
'40007	'O/C STATUS 	(0:NOACTION, 1:OPENED, 2:CLOSED)
'40008	'FULLY O/C		(0:NORMAL, 1:FULLY OPEN, 2:FULLY CLOSE)
'40009	'OVER TORQUE  ` (0: NO ALARM, 1:OVER TORQUE OPENED, 2:OVER TORQUE CLOSED) 
'40010	'OVERLOAD     ` (0: NO OVERLOAD, 1:OVERLOAD) 
'40011	'EARTH LEAKED  `(0: NO EARTH LEAKED, 1:EARTH LEAKED)
'40012	'ESD STATUS		(0: NO ESD, 1:ESD)
'40013	'DEFAULT MINPOS		'not delete when init
'40014	'DEFAULT MAXPOS		'not delete when init
'40015	'DEFAULT Span		'not delete when init
'40016	'DEFAULT L/R		'not delete when init
'40017	'SPARE
'40018	'SPARE
'40019	'SPARE
'40020	'SPARE
'========
' GATE 2
'========
'40021	'CURPOS MM		
'40022	'Command 		(0: noCommand, 1:Reset, 2:Stop, 3:Open, 4:Close, 5:ESD)
'40023	'MINPOS MM 
'40024	'MAXPOS MM
'40025	'SPAN/STEP MM
'40026	'L/R STATUS		(0: ERROR, 1:LOCAL, 2:REMOTE)
'40027	'O/C STATUS 	(0:NOACTION, 1:OPENED, 2:CLOSED)
'40028	'FULLY O/C		(0:NORMAL, 1:FULLY OPEN, 2:FULLY CLOSE)
'40029	'OVER TORQUE  ` (0: NO ALARM, 1:OVER TORQUE OPENED, 2:OVER TORQUE CLOSED) 
'40030	'OVERLOAD     ` (0: NO OVERLOAD, 1:OVERLOAD) 
'40031	'EARTH LEAKED  `(0: NO EARTH LEAKED, 1:EARTH LEAKED)
'40032	'ESD STATUS		(0: NO ESD, 1:ESD)
'40033	'DEFAULT MINPOS		'not delete when init
'40034	'DEFAULT MAXPOS		'not delete when init
'40035	'DEFAULT Span		'not delete when init
'40036	'DEFAULT L/R		'not delete when init
'40037	'SPARE
'40038	'SPARE
'40039	'SPARE
'40040	'SPARE
call Main()

sub Main()
	call GetDateTime()
	call Process()
end sub

sub Process()
dim n,CMD
dim nGate: nGate = 4
dim nG: nG = nGate-2
	
	n= GetRegisterValue(2,10)
'	n= 8
	CMD = GetRegisterValue(3,(n*20)+1)
	SELECT CASE CMD
		case 0: 'Don't Care
		case 1: call Inisialisasi(n) 
		case 2: call CMDStop(n) 
		case 3: call CMDOC(1,n)  
		case 4: call CMDOC(2,n) 
		case else:
	END SELECT
	if (n<0 or n>nG) then n=0 else n=n+1	
	SetRegisterValue 2,10,n
	
'	SetRegisterValue 3,n+22,CMD+2
end sub

sub Inisialisasi(n)
dim i: i=(n*20) : do : SetRegisterValue 3,i,0 :	i=i+1 :   loop until i>=(n*20)+10
dim dmin : dmin = GetRegisterValue(3,(n*20)+11)
dim dmax : dmax = GetRegisterValue(3,(n*20)+12)
dim dsp : dsp = GetRegisterValue(3,(n*20)+13)
dim dlr : dlr = GetRegisterValue(3,(n*20)+14)
   
   if dmin <= 0 then 
	  dmin = 0
	  SetRegisterValue 3,(n*20)+11,dmin
   end if 
   if dmax <= 0 then 
	  dmax = 6000
	  SetRegisterValue 3,(n*20)+12,dmax
   end if 
   if dsp <=0 then 
      dsp = 500
	  SetRegisterValue 3,(n*20)+13,dsp
   end if 
   if dlr <=0 then 
      dlr = 2
	  SetRegisterValue 3,(n*20)+14,dlr
   end if 
   
   SetRegisterValue 3,(n*20)+2,dmin   	'40004	'MAXPOS MM
   SetRegisterValue 3,(n*20)+3,dmax   	'40004	'MAXPOS MM
   SetRegisterValue 3,(n*20)+4,dsp   	'40005	'SPAN/STEP MM
   SetRegisterValue 3,(n*20)+5,dlr   	'40006	'L/R STATUS

   SetRegisterValue 3,(n*20)+1,0		'RESET COMMAND
end sub

'30001	'TICK 			(0-65535)
'30002	'SECOND
'30003	'MINUTE
'30004	'HOUR
'30005	'DAY
'30006	'MONTH
'30007	'YEAR
sub GetDateTime()
dim REG4X: REG4X= 2
dim addR : addR = 0  
dim d: d = Now()
dim aTick : aTick = GetRegisterValue(REG4X,addR)
	if(aTick > 65535) then aTick = 0 else aTick = aTick + 1
	SetRegisterValue REG4X, addR+0, aTick
	SetRegisterValue REG4X, addR+1, DatePart("s", d)  ' Seconds (0-59) -> Register 400001
	SetRegisterValue REG4X, addR+2, DatePart("n", d)  ' Minutes (0-59) -> Register 400002
	SetRegisterValue REG4X, addR+3, DatePart("h", d)  ' Hours (0-23) -> Register 400003
	SetRegisterValue REG4X, addR+4, DatePart("d", d)  ' Day of month (1-31) -> Register 400004
	SetRegisterValue REG4X, addR+5, DatePart("m", d)  ' Month (1-12) -> Register 400005
	SetRegisterValue REG4X, addR+6, DatePart("yyyy", d) ' Year (e.g., 2025) -> Register 400006
	
end sub 

sub CMDStop(n)
   SetRegisterValue 3,(n*20)+1,0
   SetRegisterValue 3,(n*20)+6,0
end sub


sub CMDOC(Mode,n)
dim CP : CP = GetRegisterValue(3,(n*20)+0)      'Current Posisi
dim PMin: PMin = GetRegisterValue(3,(n*20)+2)    'Min 
dim PMax: PMax = GetRegisterValue(3,(n*20)+3)    'Max 
dim Span: Span = GetRegisterValue(3,(n*20)+4)	  'Span
dim NP1 : NP1 = CP + Span    			  'NewPosisi
dim NP2 : NP2 = CP - Span  				  'NewPosisi
dim NP   								  'NewPosisi
dim IsFull : IsFull = False
	if NP1 > PMax then NP1 = PMax
	if NP2 < PMin then NP2 = PMin
	if Mode = 1 then NP = NP1 else if Mode = 2 then NP = NP2
	SetRegisterValue 3,(n*20)+0,NP 
	
	if NP >= PMax then 
	   SetRegisterValue 3,(n*20)+6,0 	'O/C STATUS
	   SetRegisterValue 3,(n*20)+7,1	'FULLY O/C
	   SetRegisterValue 3,(n*20)+1,0	'0: noCommand
	elseif NP <= PMin then
	   SetRegisterValue 3,(n*20)+6,0
	   SetRegisterValue 3,(n*20)+7,2
	   SetRegisterValue 3,(n*20)+1,0
	else
	   SetRegisterValue 3,(n*20)+7,0	'FULLY O/C
	   if mode=1 then 
		  SetRegisterValue 3,(n*20)+6,1 	'O/C STATUS
	   elseif mode = 2 then
		  SetRegisterValue 3,(n*20)+6,2 	'O/C STATUS
	   end if
	end if 
end sub

sub DebugN(N)
	SetRegisterValue 3,150,N		'DEBUG STEP: N di jalankan
end sub 
