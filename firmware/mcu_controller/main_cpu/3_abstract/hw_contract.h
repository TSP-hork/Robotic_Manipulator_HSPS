// abstract/hw_contract.h
#pragma once

// ============================================================
// hw_contract.h — Every driver/ MUST provide hw_impl.h containing:
//
// --- FOC hardware ---
//   static inline phase_t  hw_read_currents(void);
//   static inline rotor_t  hw_read_rotor(void);
//   static inline void     hw_write_pwm(phase_t duty);
//   static inline void     hw_sincos(float angle, float *s, float *c);
//   static inline void     hw_enable_gate(void);
//   static inline void     hw_disable_gate(void);
//   static inline uint32_t hw_micros(void);
//
// --- SPI slave communication ---
//   static inline volatile spi_rx_packet_t* hw_spi_rx_buf(void);
//   static inline volatile spi_tx_packet_t* hw_spi_tx_buf(void);
//   static inline uint32_t hw_spi_rx_count(void);
//
// ============================================================