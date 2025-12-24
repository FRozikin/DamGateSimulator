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
'40013	'SPARE
'40014	'TICK 			(0-65535)
'40015	'SECOND
'40016	'MINUTE
'40017	'HOUR
'40018	'DAY
'40019	'MONTH
'40020	'YEAR
'40021	'DEFAULT MINPOS		'not delete when init
'40022	'DEFAULT MAXPOS		'not delete when init
'40023	'DEFAULT Span		'not delete when init

call Main()

sub Main()
	call GetDateTime()
	call Process()
end sub

sub SetInit()
dim isInit:	isInit = GetRegisterValue(3,1)
	if isInit = 1 Then
	   Inisialisasi()
	end if    
end Sub

sub Inisialisasi()
dim i: i=0 : do : SetRegisterValue 3,i,0 :	i=i+1 :   loop until i>=19
dim dmin : dmin = GetRegisterValue(3,21)
dim dmax : dmax = GetRegisterValue(3,22)
dim dsp : dsp = GetRegisterValue(3,23)
   
   if dmin <= 0 then 
	  dmin = 0
	  SetRegisterValue 3,21,dmin
   end if 
   if dmax <= 0 then 
	  dmax = 6000
	  SetRegisterValue 3,22,dmax
   end if 
   if dsp <=0 then 
      dsp = 500
	  SetRegisterValue 3,23,dsp
   end if 
   
   SetRegisterValue 3,2,dmin   	'40004	'MAXPOS MM
   SetRegisterValue 3,3,dmax   	'40004	'MAXPOS MM
   SetRegisterValue 3,4,dsp   	'40005	'SPAN/STEP MM
end sub

sub GetDateTime()
dim REG4X: REG4X= 3
dim addR : addR = 13  
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

sub Process()
dim CMD :	CMD = GetRegisterValue(3,1)
	SELECT CASE CMD
		case 0: 'Don't Care
		case 1: call Inisialisasi() 
		case 2: call CMDStop() 
		case 3: call CMDOC(1)  
		case 4: call CMDOC(2) 
		case else:
	END SELECT
end sub

sub CMDStop()
   SetRegisterValue 3,1,0
   SetRegisterValue 3,6,0
end sub


sub CMDOC(Mode)
dim CP : CP = GetRegisterValue(3,0)      'Current Posisi
dim PMin: PMin = GetRegisterValue(3,2)    'Min 
dim PMax: PMax = GetRegisterValue(3,3)    'Max 
dim Span: Span = GetRegisterValue(3,4)	  'Span
dim NP1 : NP1 = CP + Span    			  'NewPosisi
dim NP2 : NP2 = CP - Span  				  'NewPosisi
dim NP   								  'NewPosisi
dim IsFull : IsFull = False
	if NP1 > PMax then NP1 = PMax
	if NP2 < PMin then NP2 = PMin
	if Mode = 1 then NP = NP1 else if Mode = 2 then NP = NP2
	SetRegisterValue 3,0,NP 
	
	if NP >= PMax then 
	   SetRegisterValue 3,6,0 	'O/C STATUS
	   SetRegisterValue 3,7,1	'FULLY O/C
	   SetRegisterValue 3,1,0	'0: noCommand
	elseif NP <= PMin then
	   SetRegisterValue 3,6,0
	   SetRegisterValue 3,7,2
	   SetRegisterValue 3,1,0
	else
	   SetRegisterValue 3,7,0	'FULLY O/C
	   if mode=1 then 
		  SetRegisterValue 3,6,1 	'O/C STATUS
	   elseif mode = 2 then
		  SetRegisterValue 3,6,2 	'O/C STATUS
	   end if
	end if 
end sub

sub DebugN(N)
	SetRegisterValue 3,50,N		'DEBUG STEP: N di jalankan
end sub 
