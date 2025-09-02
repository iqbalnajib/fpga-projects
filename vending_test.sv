`include "vending.sv"

module vending_test();
		logic clk; 
		logic reset; 
		logic half; 
		logic one; 
		logic bev; 
		logic bal;

		initial begin
			clk = 0;
			forever #100 clk = ~clk;
			end

		`ifdef VCS
			initial begin
				$fsdbDumpfile("./wave.fsdb");
				$fsdbDumpvars("+all");
				$fsdbDumpMDA(0, vending_test);
				$fsdbDumpSVA();
				end
		`endif

		initial begin
		reset = 0;
		half = 0;
		one = 0;

		#50 reset =1;

		#100;  
		repeat (40)
		begin 
		#100
		half = $urandom_range(0,1);
		one = $urandom_range(0,1);
		end
		$finish();
		end



		initial $monitor (" reset=%0b, half=%0b, one=%0b, bev=%0b, bal=%0b", $time, reset, half, one, bev, bal);

		vending u0(clk, reset, half, one, bev, bal);

endmodule


	


