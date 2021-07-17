// Add values with Assembly code within C code

int getSum(int a, int b);

int getSum(int a, int b)
{ 
	int sum = 0; // MOVS r0,#0x00
							 // STR r0,[sp,#0x00] (location with sum = 0)
  
	/* with Arm V6, the gcc inline assembly syntax must be used with
	   "r" for (generic) register, the compiler picks the register
		 "=r" for output register 
	   https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html
	*/
	__asm("ADD %[out], %[in_1],%[in_2]\n"
	:[out]  "=r" (sum)
	:[in_1] "r" (a),[in_2] "r" (b) 
	);
	
	/* Translated in dissassembly by :
	LDR           r0,[sp,#0x08] (location with a = 20)
	LDR           r1,[sp,#0x04] (location with b = 30)
	ADD           r0,r0,r1			(add 20 + 30 in R0) */
	


	return sum; //STR r0,[sp,#0x00]
	
	// Ligther version with indexes in the order as
	// %0 => sum , %1 => a , %2 => b
	/* __asm("ADD %0, %1,%2\n"
	: "=r" (sum)
	: "r" (a), "r" (b)
	); */
	
}


static int z; // declared as global variable to add it to watch list in Keil

int main (void)
{
	int x, y;
	x = 20;
	y = 30;
	while(1)
	{
			z = getSum(x,y);
	}
//return (0);
}
