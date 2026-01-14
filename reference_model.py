import numpy as np
from scipy import signal

# Fixed-point to float conversion (Q8.8)
def fixed_to_float(fixed_val):
    return fixed_val / 256.0

# Float to fixed (Q8.8)
def float_to_fixed(float_val):
    return int(np.round(float_val * 256))

# Input data (match testbench: ramp 0 to 15*16=240, scaled to Q8.8 but treat as float here)
input_data = np.array([i * 16 for i in range(16)]) / 256.0  # Float equivalents

# FIR reference (floating-point)
fir_coeffs = [0.25, 0.25, 0.25, 0.25]
fir_out = signal.lfilter(fir_coeffs, [1.0], input_data)

# IIR reference (floating-point)
iir_a = [1.0, -0.5]  # Denom: 1 - a*z^-1
iir_b = [0.5]        # Num: (1-a)
iir_out = signal.lfilter(iir_b, iir_a, fir_out)

# FFT reference (floating-point, process in blocks of 4)
fft_out = []
for block in np.array_split(iir_out, 4):  # 16 samples / 4 = 4 blocks
    fft_block = np.fft.fft(block, n=4) / 4  # Normalize
    fft_out.append(fft_block)

# Print for comparison (convert Verilog outputs to float and compare manually)
print("Floating-point FFT Real/Imag (for each block):")
for block in fft_out:
    print([c.real for c in block], [c.imag for c in block])

# Fixed vs Floating Comparison: Simulate fixed-point in Python
# FIR fixed
fir_out_fixed = np.convolve(input_data, fir_coeffs, mode='full')[:len(input_data)]  # Approx
# ... (extend for full pipeline; compare precision loss: e.g., MSE between float and fixed sim)
mse = np.mean((fir_out - fir_out_fixed)**2)
print(f"Precision Comparison (MSE between float and approx fixed FIR): {mse}")