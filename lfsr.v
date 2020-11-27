//---------------------------------------------------------------------------------------
// lfsr регистр с подсчетом длины псевдослучайной последовательности
//
//---------------------------------------------------------------------------------------

module lfsr (input [7:0] seed, input load, input clk, input rst, output reg [7:0] data, output reg out);
reg [7:0] reg_seed; //Статовое значение
reg [8:0] cnt;
reg [8:0] buf_cnt;
reg [31:0] buffer;
reg [8:0] period; //Длина ПС-последовательности
reg [3:0] flag;
wire xor_feedback; 
assign xor_feedback = {((reg_seed[7]^reg_seed[5])^reg_seed[4])^reg_seed[3]}; // Выборка разрядов для обраной связи

always @(posedge clk)
	begin
		if (!rst)
			begin
			reg_seed <= 8'h0; 
			out <= 0;
			cnt <= 0;
			buffer <= 0;
			flag <= 0;
			period <= 0;
			data <= 0;
			end
		else 
			begin
				out <= reg_seed[7];
			if(load)
				reg_seed <= seed;
			else begin
				reg_seed <= {reg_seed[6:0], xor_feedback};
				data <= reg_seed;
				cnt <= cnt+1;
				case (cnt)
					1: buffer[31:24] <= reg_seed;
					2: buffer[23:16] <= reg_seed;
					3: buffer[15:8] <= reg_seed;
					4: buffer[7:0]<= reg_seed;
				endcase						
				case (reg_seed)
					buffer[31:24]:  
								begin 
								flag[0] <= 1; 
								buf_cnt <= cnt;
								end
					buffer[23:16]: 
								begin 
									if (cnt == buf_cnt+1) begin
										flag[1] <= 1; 
										buf_cnt <= cnt;
									end
									else begin
										flag <=0;
										buf_cnt <=0;
									end
								end
					buffer[15:8]:  
								begin 
									if (cnt == buf_cnt+1) begin
										flag[2] <= 1; 
										buf_cnt <= cnt;
									end
									else begin
										flag <=0;
										buf_cnt <=0;
									end
								end
					buffer[7:0]:   
								begin 
									if (cnt == buf_cnt+1) 
										flag[3] <= 1; 
									else begin
										flag <=0;
										buf_cnt <=0;
									end
								end
				endcase
				if (flag == 8'hF) begin
					period <= cnt-4;
					cnt <=0;
					flag <=0;
					buf_cnt <= 0;
				end


			end
			end
	end
endmodule 