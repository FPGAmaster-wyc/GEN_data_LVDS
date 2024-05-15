module uart_rx #(
	parameter START_BITS=1,
	parameter DATA_BITS=8,
	parameter PARITY="NONE",
	parameter STOP_BITS=1,
	parameter BAUD_DIVIDER=65535
)(
	input	reset,
	input	clk_in,
	output	[7:0] data,
	output	valid,
	output	parity_error,
	output	line_error,
	input	rxd_in
);
localparam PARITY_BITS=(PARITY=="NONE")?0:1;
localparam PARITY_INIT=(PARITY=="ODD")?1'b1:1'b0;
localparam SAMPLE_POINT=BAUD_DIVIDER/2;

wire rx_en;

reg [15:0] div_cnt;
reg rxd_0, rxd_r;
reg [7:0] data_r;
reg par_r;
reg [2:0] bit_cnt;
reg valid_r;

integer state, next_state;
localparam S_IDLE=0,S_START=1,S_DATA=2,S_PARITY=3,S_STOP=4, S_ERROR=5;

assign data = data_r;
assign valid = valid_r;
assign line_error = state==S_ERROR;
assign parity_error = par_r;

assign rx_en = div_cnt==SAMPLE_POINT-1;

always @(posedge clk_in)
begin
	rxd_0 <= rxd_in;
	rxd_r <= rxd_0;
end

always @(posedge clk_in, posedge reset)
begin
	if(reset) begin
		div_cnt <= 'b0;
	end
	else if(state==S_IDLE) begin
		div_cnt <= 'b0;
	end
	else if(div_cnt==BAUD_DIVIDER-1)begin
		div_cnt <= 'b0;
	end
	else begin
		div_cnt <= div_cnt+1;
	end
end

always @(posedge clk_in, posedge reset)
begin
	if(reset) begin
		state <= S_IDLE;
	end
	else begin
		state <= next_state;
	end
end

always @(*)
begin
	case(state)
		S_IDLE: begin
			if(rxd_r==1'b0) begin
				next_state = S_START;
			end
			else begin
				next_state = S_IDLE;
			end
		end
		S_START: begin
			if(rx_en) begin
				if(bit_cnt==START_BITS-1) begin
				       if(rxd_r==1'b0) begin
					       next_state = S_DATA;
				       end
				       else begin
					       next_state = S_IDLE;
				       end
				end
				else begin
					next_state = S_START;
				end
			end
			else begin
				next_state = S_START;
			end
		end
		S_DATA: begin
			if(rx_en) begin
				if(bit_cnt==DATA_BITS-1) begin
					if(PARITY_BITS==0)
						next_state = S_STOP;
					else
						next_state = S_PARITY;
				end
				else begin
					next_state = S_DATA;
				end
			end
			else begin
				next_state = S_DATA;
			end
		end
		S_PARITY: begin
			if(rx_en) begin
				next_state = S_STOP;
			end
			else begin
				next_state = S_PARITY;
			end
		end
		S_STOP: begin
			if(rx_en) begin
				if(rxd_r == 1'b1) begin
					next_state = S_IDLE;
				end
				else begin
					next_state = S_ERROR;
				end
			end
			else begin
				next_state = S_STOP;
			end
		end
		S_ERROR: begin
			if(rxd_r == 1'b1) begin
				next_state = S_IDLE;
			end
			else begin
				next_state = S_ERROR;
			end
		end
		default: begin
			next_state = 'bx;
		end
	endcase
end

always @(posedge clk_in)
begin
	if(state!=next_state) begin
		bit_cnt <= 'b0;
	end
	else if(rx_en) begin
		bit_cnt <= bit_cnt + 1;
	end
end

always @(posedge clk_in, posedge reset)
begin
	if(reset) begin
		par_r <= 'bx;
		data_r <= 'bx;
	end
	else case(state)
		S_START: begin
			par_r <= PARITY_INIT;
		end
		S_DATA: begin
			if(rx_en) begin
				data_r <= {rxd_r,data_r[7:1]};
				par_r <= par_r^rxd_r;
			end
		end
		S_PARITY: begin
			if(rx_en) begin
				par_r <= par_r^rxd_r;
			end
		end
	endcase
end

always @(posedge clk_in, posedge reset)
begin
	if(reset) 
		valid_r <= 1'b0;
	else if(next_state==S_STOP && rx_en)
		valid_r <= 1'b1;
	else
		valid_r <= 1'b0;
end
endmodule
