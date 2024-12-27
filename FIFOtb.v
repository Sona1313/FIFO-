module FIFOtb_v;

	// Inputs
	reg clk;
	reg rst_n;
	reg wr_en;
	reg rd_en;
	reg [7:0] wr_data;

	// Outputs
	wire [7:0] rd_data;
	wire full;
	wire empty;

	// Instantiate the Unit Under Test (UUT)
	FIFO uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.wr_en(wr_en), 
		.rd_en(rd_en), 
		.wr_data(wr_data), 
		.rd_data(rd_data), 
		.full(full), 
		.empty(empty)
	);

	// Clock Generation
	always #5 clk = ~clk;  // 10 ns clock period (100 MHz)

	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 0;
		wr_en = 0;
		rd_en = 0;
		wr_data = 0;

		// Reset the FIFO
		#20;
		rst_n = 1;  // Release reset

		// Write data to FIFO
		#10;
		write_data(8'hA1);
		write_data(8'hB2);
		write_data(8'hC3);
		write_data(8'hD4);
		
		// Read data from FIFO
		#20;
		read_data();
		read_data();
		read_data();
		read_data();

		// Test FIFO Full and Empty conditions
		#30;
		$stop; // Stop the simulation
	end

	// Task to write data to the FIFO
	task write_data(input [7:0] data);
	begin
		@(posedge clk); 
		if (!full) begin
			wr_data = data;
			wr_en = 1;
			@(posedge clk); 
			wr_en = 0;
		end
	end
	endtask

	// Task to read data from the FIFO
	task read_data();
	begin
		@(posedge clk); 
		if (!empty) begin
			rd_en = 1;
			@(posedge clk); 
			rd_en = 0;
		end
	end
	endtask

endmodule
