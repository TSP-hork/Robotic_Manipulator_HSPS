module top_test (
    input  logic clk,       // 27 MHz
    input  logic btn1,      // Reset (S1)
    
    // Encoder
    input  logic enc_a,
    input  logic enc_b,
    input  logic enc_z,
    
    // SPI Loopback (Physically connect MOSI pin to MISO pin on the board)
    output logic spi_cs,
    output logic spi_sck,
    output logic spi_mosi,
    input  logic spi_miso,

    // PWM/Deadtime Output
    output logic pwm_h,
    output logic pwm_l,
    
    // LEDs for visualization
    output logic [5:0] led
);
    logic rst_n;
    assign rst_n = btn1;

    // --- 1. ENCODER ---
    logic [31:0] enc_position;
    logic [31:0] enc_velocity_period;

    quadrature_decoder #( .CLK_FREQ(27_000_000) ) encoder_inst (
        .clk(clk), .rst_n(rst_n),
        .a_in(enc_a), .b_in(enc_b), .z_in(enc_z),
        .position(enc_position),
        .period(enc_velocity_period)
        // ... other outputs not used in this test
    );

    // --- 2. PWM & DEADTIME ---
    logic pwm_raw_out;
    // We will control PWM duty cycle with the encoder!
    logic [15:0] pwm_duty_from_encoder;
    // Use encoder position to control duty. Scale it down to fit 16 bits.
    assign pwm_duty_from_encoder = enc_position[20:5];

    pwm_generator pwm_inst (
        .clk(clk), .rst_n(rst_n),
        .enable(1'b1),
        .period(16'd27000), // ~1kHz PWM
        .duty(pwm_duty_from_encoder), // Controlled by encoder!
        .pwm_out(pwm_raw_out)
    );
    
    deadtime dt_inst (
        .clk(clk), .rst_n(rst_n),
        .pwm_in(pwm_raw_out),
        .dt_ticks(8'd50),
        .pwm_h(pwm_h),
        .pwm_l(pwm_l)
    );

    // --- 3. SPI LOOPBACK TEST ---
    logic [31:0] spi_data_to_send;
    logic [31:0] spi_data_received;
    logic        start_spi_tx;
    logic        spi_is_done;
    
    // We will send a known pattern
    assign spi_data_to_send = 32'hDEADBEEF;

    // Trigger SPI transfer every ~1 second to see it on LEDs
    logic [24:0] slow_timer;
    always_ff @(posedge clk) slow_timer <= slow_timer + 1;
    assign start_spi_tx = (slow_timer == 25'd0);

    spi_master #( .DATA_WIDTH(32), .CLK_DIV(13) ) spi_test_inst (
        .clk(clk), .rst_n(rst_n),
        .start(start_spi_tx),
        .tx_data(spi_data_to_send),
        .rx_data(spi_data_received),
        .done(spi_is_done),
        // ... physical pins ...
        .spi_cs_n(spi_cs), .spi_sck(spi_sck), .spi_mosi(spi_mosi), .spi_miso(spi_miso)
    );
    
    // --- 4. VISUALIZATION ---
    // LEDs 0,1 show PWM/Deadtime
    assign led[0] = ~pwm_h;
    assign led[1] = ~pwm_l;

    // LED 2 shows SPI CS signal
    assign led[2] = spi_cs;

    // LEDs 3,4,5 show test status
    logic spi_test_ok;
    // Check if we received what we sent
    always_ff @(posedge clk)
        if (spi_is_done)
            spi_test_ok <= (spi_data_received == spi_data_to_send);

    assign led[3] = ~spi_test_ok; // LED3 lights up if test PASSED
    assign led[4] = ~spi_sck;      // LED4 blinks with SPI clock during transfer
    assign led[5] = ~btn1;       // LED5 lights up when reset is pressed
    
endmodule