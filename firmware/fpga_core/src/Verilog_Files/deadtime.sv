module deadtime (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       pwm_in,    
    input  logic [7:0] dt_ticks,  // Setting: how many beats to wait for (for example, 50)
    output logic       pwm_h,     // To the upper transistor
    output logic       pwm_l      // To the lower transistor
);

    // Delay Counters
    logic [7:0] rise_cnt;
    logic [7:0] fall_cnt;
    
    // Internal safe signals
    logic h_out, l_out;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise_cnt <= 0;
            fall_cnt <= 0;
            h_out <= 0;
            l_out <= 0;
        end else begin
            // Logic for High Side (Front-end delay)
            if (pwm_in == 1'b1) begin
                if (rise_cnt < dt_ticks) rise_cnt <= rise_cnt + 1;
                else                     h_out    <= 1'b1; // Enable only after delay
            end else begin
                rise_cnt <= 0;
                h_out    <= 1'b0; // fast off
            end

            // Logic for Low Side (Inversion + Delay)
            if (pwm_in == 1'b0) begin
                if (fall_cnt < dt_ticks) fall_cnt <= fall_cnt + 1;
                else                     l_out    <= 1'b1; // Enabling complementary
            end else begin
                fall_cnt <= 0;
                l_out    <= 1'b0;
            end
        end
    end

    assign pwm_h = h_out;
    assign pwm_l = l_out;

endmodule