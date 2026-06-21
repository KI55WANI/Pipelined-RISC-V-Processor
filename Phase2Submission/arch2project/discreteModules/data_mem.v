module data_mem (
    input wire clk,
    input wire rst,
    input wire [63:0] address,
    input wire [63:0] write_data,
    input wire mem_write,
    input wire mem_read,
    input wire [1:0] mem_type,
    input wire request,
    output reg [63:0] mem_out
);

    // Memory and address calculations
    reg [7:0] mem [0:8191];
    wire [12:0] block0, block1, block2, block3;

    assign block0 = (address[12:0] & 13'h1ffc) + 13'd0;
    assign block1 = (address[12:0] & 13'h1ffc) + 13'd1;
    assign block2 = (address[12:0] & 13'h1ffc) + 13'd2;
    assign block3 = (address[12:0] & 13'h1ffc) + 13'd3;

    // Initialize memory from file
    initial begin
        $readmemh("data_mem.hex", mem);
    end

    // Write memory on falling edge of clock
    always @(negedge clk) begin
        if (mem_write) begin
            case (mem_type)
                2'b00: begin
                    mem[block0] <= write_data[7:0];
                end
                2'b01: begin
                    mem[block0] <= write_data[7:0];
                    mem[block1] <= write_data[15:8];
                end
                2'b10: begin
                    mem[block0] <= write_data[7:0];
                    mem[block1] <= write_data[15:8];
                    mem[block2] <= write_data[23:16];
                    mem[block3] <= write_data[31:24];
                end
                default: ; // do nothing
            endcase
        end
    end

    // Register to detect rising edge of request
    reg request_reg;
    wire request_rising = request & ~request_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            request_reg <= 1'b0;
        else
            request_reg <= request;
    end

    // Read memory on rising edge of clk, triggered by request signal
    always @(posedge clk) begin
        if (request_rising && mem_read) begin
            case (mem_type)
                2'b00: mem_out <= {{56{mem[block0][7]}}, mem[block0]};
                2'b01: mem_out <= {{48{mem[block1][7]}}, mem[block1], mem[block0]};
                2'b10: mem_out <= {{32{mem[block3][7]}}, mem[block3], mem[block2], mem[block1], mem[block0]};
                default: mem_out <= 64'bx;
            endcase
        end else begin
            mem_out <= 64'd0; // or keep previous value
        end
    end

endmodule
