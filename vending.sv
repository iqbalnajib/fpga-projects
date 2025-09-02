module vending(
		input logic clk, 
		input logic reset, 
		input logic half, 
		input logic one, 
		output logic bev, 
		output logic bal
		);

		logic [2:0] ps, ns;

		parameter int S0 = 3'b000;
		parameter int S1 = 3'b001;
		parameter int S2 = 3'b010;
		parameter int S3 = 3'b011;
		parameter int S4 = 3'b100;
		parameter int S5 = 3'b101;

		// NSL
		always_comb begin
		case (ps)
	000: begin if (one == 1) ns = S2; 
		else if (half == 1) ns = S1;
		else ns = S0; end
	001: begin if (one == 1) ns = S3; 
		else if (half == 1) ns = S2;
		else ns = S1; end
	010: begin if (one == 1) ns = S4; 
		else if (half == 1) ns = S3;
		else ns = S2; end
	011: begin if (one == 1) ns = S5; 
		else if (half == 1) ns = S4;
		else ns = S1; end
	100: ns = S0; 
	101: ns = S0; 
	default: ns = 'hx;
	endcase
	end
	
		// SR
		always_ff @ (posedge clk, negedge reset)
		begin if (reset == 0) ps <= 0;
		else ps <= ns;
		end

		// OPL
		always_comb begin
		case (ps)
	S0: begin bev = 0; bal = 0; end
	S1: begin bev = 0; bal = 0; end
	S2: begin bev = 0; bal = 0; end
	S3: begin bev = 0; bal = 0; end
	S4: bev = 1;
	S5: begin bal = 1; bev = 1; end
	default: begin bev = 'hx;
		       bal = 'hx; end
		endcase
		end
endmodule

	


