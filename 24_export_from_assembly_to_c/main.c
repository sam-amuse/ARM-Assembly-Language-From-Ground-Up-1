int Number(void);

int value;
int main()
{
	while(1)
	{
			value = Number(); 
		  // This line is translated in assembly by
			// MOVW    r1,#0x00
			// MOVT    r1,#0x2000
			// STR     r0,[r1,#0x00]
			// The subroutine returned value expected in R0 is stored in 0x20000000 (RAM memory location of "value")
			// This is defined in the PCSAA (Procedure Call Standard for the ARM Architecture)
			// section 5.1.1 Core registers
	}
}
