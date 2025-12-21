call Main()


sub Main()
	'Fungsi Jam di Input Reg. 3x
	call GetDateTime(2) 'GDT(2)
	
	'Inisialisasi 
	call SetInit()
	call Process()
end sub



'REG3X4X = 2 utk AI, 3 utk AO
sub GetDateTime(REG3X4X)
dim d
dim addS : addS = 1
dim addM : addM = 2
dim addH : addH = 3
dim addD : addD = 4
dim addN : addN = 5
dim addY : addY = 6 

	d = Now()
	SetRegisterValue REG3X4X, addS, DatePart("s", d)  ' Seconds (0-59) -> Register 400001
	SetRegisterValue REG3X4X, addM, DatePart("n", d)  ' Minutes (0-59) -> Register 400002
	SetRegisterValue REG3X4X, addH, DatePart("h", d)  ' Hours (0-23) -> Register 400003
					 
	SetRegisterValue REG3X4X, addD, DatePart("d", d)  ' Day of month (1-31) -> Register 400004
	SetRegisterValue REG3X4X, addM, DatePart("m", d)  ' Month (1-12) -> Register 400005
	SetRegisterValue REG3X4X, addY, DatePart("yyyy", d) ' Year (e.g., 2025) -> Register 400006

	'Untuk memudahkan debug, salin nilai detik ke address 40031
	SetRegisterValue 3, 40, DatePart("s", d)  ' Seconds (0-59) -> Register 40040
	
end Sub

sub SetInit()
dim isInit
	isInit = GetRegisterValue(3,0)
	if isInit = 1 Then
	   Inisialisasi()
	end if    
end Sub

sub Inisialisasi()
'Trigger: 40001: 1 				'(3,0,1)
   SetRegisterValue 3,1,0   	'No Command 
   SetRegisterValue 3,2,0   	'No STATUS Command 
   SetRegisterValue 3,3,0   	'L/R : Default 0 : Local 
   SetRegisterValue 3,4,0   	'MinPos MM
   SetRegisterValue 3,5,0   	'MinPos MM
   SetRegisterValue 3,6,6000    'MaxPos MM
   SetRegisterValue 3,7,500     'STEP MM Saat Open Atau Close
   SetRegisterValue 3,8,0		'Fully Open/Close (1:Open, 2:Close) 
   SetRegisterValue 3,9,0		'Opened/Closed (1:Opened, 2:Closed) 
   SetRegisterValue 3,10,0      'CurPos MM
   SetRegisterValue 3,20,0		'Reset Current Cmd
   SetRegisterValue 3,0,0       'Reset Succesed
   call DebugN(0)				'Reset Debug
end sub

sub Process()
dim CMD
	CMD = GetRegisterValue(3,1)
	SELECT CASE CMD
	case 0: 'SetRegisterValue 3,21,1
	case 1: SetRegisterValue 3,20,1
	case 2: SetRegisterValue 3,20,2
			call CMDStop()
	case 3: SetRegisterValue 3,20,3
			call CMDOC(1)
	case 4: SetRegisterValue 3,20,4
			call CMDOC(2)
	
	case else:
	END SELECT
	
end sub

sub CMDStop()
   'SetRegisterValue 3,8,0
   SetRegisterValue 3,9,0
   SetRegisterValue 3,1,0
   SetRegisterValue 3,20,0
end sub


sub CMDOC(Mode)
dim CP : CP = GetRegisterValue(3,10)      'Current Posisi
dim Span: Span = GetRegisterValue(3,7)	  'Span
dim PMin: PMin = GetRegisterValue(3,5)    'Min 
dim PMax: PMax = GetRegisterValue(3,6)    'Max 
dim NP1 : NP1 = CP + Span    								  'NewPosisi
dim NP2 : NP2 = CP - Span  								  'NewPosisi
dim NP   								  'NewPosisi
dim IsFull : IsFull = False
	
'    call DebugN(1)
'	if(mode<>1 or mode <>2) then exit sub
	if NP1 > PMax then NP1 = PMax
	if NP2 < PMin then NP2 = PMin
	if Mode = 1 then NP = NP1 else if Mode = 2 then NP = NP2
'    call DebugN(NP)
	SetRegisterValue 3,10,NP 
	
	if NP >= PMax then 
	   SetRegisterValue 3,8,1
	   SetRegisterValue 3,9,0
	   SetRegisterValue 3,1,0
	   SetRegisterValue 3,20,0
	elseif NP <= PMin then
	   SetRegisterValue 3,8,2
	   SetRegisterValue 3,9,0
	   SetRegisterValue 3,1,0
	   SetRegisterValue 3,20,0
	else
	   SetRegisterValue 3,8,0
	   if mode=1 then 
		  SetRegisterValue 3,9,1
	   elseif mode = 2 then
		  SetRegisterValue 3,9,2
	   end if
	end if 
end sub

sub DebugN(N)
'idx register debug: 50
	SetRegisterValue 3,50,N		'DEBUG STEP: 2 tidak  di jalankan
end sub 

	   'IDX: 0, > 0 : Reset
	   'IDX: 1:   'Command
	   '	 0: No Action
	   '     1: ESD  			
	   '     2: STOP  			
	   '     3: OPEN  			:3 Open : OK
	   '     4: CLOSE			:4 Close : OK 
	   'IDX: 2 : 'Status
	   '	 0:0000 0000 : 0  : Normal, No Status CMD
	   '     0:0000 0001 : 1  : ESD Command Send
	   '     0:0000 0010 : 2  : STOP Command Send
	   '     0:0000 0100 : 4  : OPEN Command Send
	   '     0:0000 1000 : 8  : CLOSE Command Send
	   '     0:0001 0000 : 16 : OPENED
	   '     0:0010 0000 : 32 : CLOSED
	   'IDX: 3 : L/R status
	   '	 0 : LOCAL
	   '     1 : REMOTE
	   'IDX: 4 : ALARM STATUS (16 BIT)
	   'IDX: 5 : SET POINT NOL (0 %)
	   'IDX: 6 : SET POINT MAX (100%) dalam MM
	   'IDX: 7 : STEP Open/Close
	   'IDX: 8 : 
	   '	   0 : Status FULLY NORMAL
	   '	   1 : Status FULLY Open
	   '	   2 : Status FULLY Close	
	   'IDX: 9 : Opened/Closed (0:normal, 1:opened, 2:closed)
	   'IDX: 10: POSISI PINTU (Dari Potensiometer RS485)
	   

