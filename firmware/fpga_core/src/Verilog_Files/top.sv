module top (
    input  logic clk,       // 27 MHz
    input  logic btn1,      // Reset (S1)
    
    // Encoder inputs (Pins 25, 26)
    input  logic enc_a,
    input  logic enc_b,

    // Leds
    output logic [5:0] led
);

    logic rst_n;
    assign rst_n = btn1; // Button S1

    // Inner signals
    logic [31:0] encoder_val_arr [0:5]; 
    logic [15:0] pwm_duty_arr    [0:5];
    logic        enable_arr      [0:5];
    logic        pwm_raw;
    logic        pwm_h, pwm_l;

    // 1. Storage
    system_storage #(.AXIS_COUNT(6)) storage (
        .clk(clk), .rst_n(rst_n),
        .write_en(1'b0), .addr(8'd0), .wdata(32'd0), .rdata(),
        .encoders_in(encoder_val_arr),
        .pwm_duties(pwm_duty_arr),
        .enables(enable_arr)
    );

    // 2. ENCODER 
    quadrature_decoder enc0 (
        .clk(clk), .rst_n(rst_n),
        .a_in(enc_a), .b_in(enc_b),
        .count(encoder_val_arr[0]) 
    );

    // 3. PWM GENERATOR slow for test
    // Period = 13.500.000 cycle 
    // Duty   =  6.750.000 cycle 
    pwm_generator pwm0 (
        .clk(clk), .rst_n(rst_n),
        .enable(1'b1), 
        .period(16'd27000), 

        .duty(16'd13500),   
        .pwm_out(pwm_raw),
        .center_event()
    );
    
    // slow for test
    logic [24:0] slow_cnt;
    logic        slow_pwm_raw;
    always_ff @(posedge clk) slow_cnt <= slow_cnt + 1;
    assign slow_pwm_raw = slow_cnt[24]; 

    // 4. DEAD TIME 
    deadtime dt0 (
        .clk(clk), .rst_n(rst_n),
        .pwm_in(slow_pwm_raw), 
        .dt_ticks(8'd50), 
        .pwm_h(pwm_h),
        .pwm_l(pwm_l)
    );

    // --- VISUALIZATION ---
    // LED 0 и 1: pwm for gate driver 0 for high 1 for low 
    // it should not be lit at the same time. 
    assign led[0] = ~pwm_h; 
    assign led[1] = ~pwm_l; 

    // LED 5..2: encoder
    assign led[5:2] = ~encoder_val_arr[0][3:0];

endmodule