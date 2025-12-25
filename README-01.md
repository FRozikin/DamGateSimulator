DamGateSimulator 
----------------
VBScript untuk mensimulasikan Pintu Air DAM dengan program ModRSsim2. (https://sourceforge.net/projects/modrssim2/)
Register Modbus yang digunakan:
1. Analog Input (3xxxx), index : 1: detik,
                                 2: menit,
                                 3: jam
                                 4: tanggal
                                 5: bulan
                                 6: tahun
2. Holding Register (4xxxx), index:
	   'IDX: 0, > 0 : Reset
	   'IDX: 1:   'Command
	   '	   0: No Action
	   '     1: ESD  			
	   '     2: STOP  			
	   '     3: OPEN  			:3 Open : OK
	   '     4: CLOSE			  :4 Close : OK 
	   'IDX: 2 : 'Status
	   '	 0:0000 0000 : 0  : Normal, No Status CMD
	   '     0:0000 0001 : 1  : ESD Command Send
	   '     0:0000 0010 : 2  : STOP Command Send
	   '     0:0000 0100 : 4  : OPEN Command Send
	   '     0:0000 1000 : 8  : CLOSE Command Send
	   '     0:0001 0000 : 16 : OPENED
	   '     0:0010 0000 : 32 : CLOSED
	   'IDX: 3 : L/R status
	   '	   0 : LOCAL
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
	   'IDX: 40: detik (kebutuhan debug saja) 
4.                              
