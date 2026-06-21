module instruction_memory(clk, rst, address, instruction_out, request);

    input clk, rst, request;
    input [31:0] address;

    output reg [31:0] instruction_out;

    wire [31:0] block0, block1, block2, block3;
    wire [15:0] mem_index0, mem_index1, mem_index2, mem_index3;

    assign block0 = (address & 32'hffff_fffc) + 32'd0;
    assign block1 = (address & 32'hffff_fffc) + 32'd1;
    assign block2 = (address & 32'hffff_fffc) + 32'd2;
    assign block3 = (address & 32'hffff_fffc) + 32'd3;

    assign mem_index0 = block0[15:0];
    assign mem_index1 = block1[15:0];
    assign mem_index2 = block2[15:0];
    assign mem_index3 = block3[15:0];

	 reg [7:0] mem [0:32767];  // 32K x 1 byte
    integer i;

    always @(negedge clk or negedge rst) begin
        if (~rst) begin
            $readmemh("ins_mem.hex", mem);
        end
    end

    always @(posedge request) begin
        instruction_out[7:0]   = mem[mem_index0];
        instruction_out[15:8]  = mem[mem_index1];
        instruction_out[23:16] = mem[mem_index2];
        instruction_out[31:24] = mem[mem_index3];
    end
endmodule
