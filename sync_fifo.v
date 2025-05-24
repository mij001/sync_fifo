module sync_fifo (
    input clk,
    input nrst,
    input upstr_d_valid,
    input [32:0] upstr_data,
    output upstr_d_ready,

    output downstr_d_valid,
    output reg [32:0] downstr_data,
    input downstr_d_ready
    );
    reg [32:0] buffer [1023:0];
    reg [9:0] upstr_ptr;
    reg [9:0] downstr_ptr;
    reg [32:0] downstr_data_next,
    reg [32:0] upstr_data_next,

    reg [9:0] upstr_ptr_next;
    reg [9:0] downstr_ptr_next;

    reg [9:0] filled_amt;
    reg [9:0] filled_amt_next;

    reg buf_full;
    reg buf_empty;

    reg buf_full_next;
    reg buf_empty_next;

    wire read_en;
    wire write_en;

    assign read_en = upstr_d_valid & upstr_d_ready;
    assign write_en = downstr_d_valid & downstr_d_ready;
    assign upstr_d_ready = ~buf_full;
    assign downstr_d_valid = ~buf_empty;

    always @* begin
        /* read-write pointer chage calc */
        if (write_en) begin
            upstr_ptr_next = upstr_ptr + 1;
            upstr_data_next = upstr_data;
        end else begin
            upstr_ptr_next = upstr_ptr;
        end

        if (read_en) begin
            if (downstr_ptr == 0) begin
                downstr_ptr_next = downstr_ptr + 1;

                // downstr_ptr_next = 10'0;
            end else begin
                downstr_ptr_next = downstr_ptr;
            end
        end else begin
            downstr_ptr_next = downstr_ptr;
        end
        if ((write_en && read_en) || (~write_en && ~read_en)) begin
            filled_amt_next = filled_amt;
        end else if (write_en) begin
            filled_amt_next = filled_amt+1;
        end else begin
            filled_amt_next = filled_amt-1;
        end

        if (downstr_ptr == upstr_ptr && filled_amt == 10'd1023) begin
            buf_full_next = 1'b1;
        end else begin
            buf_full_next = 1'b0;
        end
        if (downstr_ptr == upstr_ptr && filled_amt == 0) begin
            buf_empty_next = 1'b1;
        end else begin
            buf_empty_next = 1'b0;
        end
    end

    always @(posedge clk or negedge nrst) begin
        if (~nrst) begin
            upstr_ptr <= 0;
            downstr_ptr <= 0;
            filled_amt <= 0;
            buf_full <= 0;
            buf_empty <= 1;
        end else begin
            upstr_ptr <= upstr_ptr_next;
            downstr_ptr <= downstr_ptr_next;
            filled_amt <= filled_amt_next;
            buf_full <= buf_full_next;
            buf_empty <= buf_empty_next;
        end
        
    end
    
endmodule
