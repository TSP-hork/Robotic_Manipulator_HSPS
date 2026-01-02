module pwm_generator (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        enable,      // Main switch
    input  logic [15:0] period,      // Set the frequency (for example, 27000)
    input  logic [15:0] duty,        
    output logic        pwm_out,     // Raw PWM signal
    output logic        center_event 
);

    logic [15:0] cnt;
    logic        dir; // 0 = up, 1 = down

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            dir <= 0;
        end else begin
            if (enable) begin
                // Up-Down Counter Logic (Triangle)
                if (dir == 0) begin
                    if (cnt >= period) begin
                        dir <= 1;       // We've reached the top, and we're turning around
                        cnt <= cnt - 1;
                    end else begin
                        cnt <= cnt + 1;
                    end
                end else begin
                    if (cnt == 0) begin
                        dir <= 0;       // We've reached the bottom, so we turn around
                        cnt <= cnt + 1;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
            end else begin
                // If enable - reset
                cnt <= 0;
                dir <= 0;
            end
        end
    end

    // Comparison: While the counter is less than the duty cycle -> On
    assign pwm_out = (cnt < duty) && enable;
    
    // Center event (when the counter is at its maximum)
    assign center_event = (cnt == period);

endmodule