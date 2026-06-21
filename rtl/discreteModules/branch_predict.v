module branch_predict(clock, reset, beq, bne, taken, pc_curr, sb_imm, predicted_pc, predictionT, update, pc_old);

	 input clock, reset;
    input beq, bne, taken, update;
    input [11:0] sb_imm;
    input [31:0] pc_curr;
    
    output wire [31:0] pc_old;
    output reg predictionT;
    output reg [31:0] predicted_pc;

    reg taken_latch, update_latch;
    reg [1:0] count;
    reg [31:0] ext;

    parameter first_not_taken = 2'b00,
              second_not_taken = 2'b01,
              second_taken = 2'b10,
              first_taken = 2'b11;

    assign pc_old = pc_curr;

	always @(*) begin
		ext = {{20{sb_imm[11]}}, sb_imm};
		if (beq | bne) begin
        if (predictionT)
            predicted_pc = pc_curr + (ext << 2);
        else
            predicted_pc = pc_curr + 32'd4;
    end else begin
        predicted_pc = pc_curr + 32'd4;
    end


        taken_latch = taken;
        update_latch = update;
    end

    always @(posedge clock or negedge reset) begin
        if (~reset) begin
            count <= first_not_taken;
            predictionT <= 1'b0;
        end 
        else if (update_latch) begin
            case (taken_latch)
                1'b0: begin 
                    if (count != 2'b00)
                        count <= count - 2'b01;
                    else
                        count <= 2'b00;
                end
                1'b1: begin
                    if (count != 2'b11)
                        count <= count + 2'b01;
                    else
                        count <= 2'b11;
                end
            endcase
        end

        case (count)
            second_taken, first_taken: predictionT <= 1'b1;
            default: predictionT <= 1'b0;
        endcase
    end

endmodule
